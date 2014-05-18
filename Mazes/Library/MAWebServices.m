//
//  MAWebServices.m
//  Mazes
//
//  Created by Andre Muis on 12/26/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAWebServices.h"

#import "MACloud.h"
#import "MAConstants.h"
#import "MALatestVersion.h"
#import "MAMaze.h"
#import "MAUserCounter.h"
#import "MAUtilities.h"

@interface MAWebServices ()

@property (readonly, strong, nonatomic) Reachability *reachability;
@property (readonly, strong, nonatomic) FatFractal *fatFractal;
@property (readonly, strong, nonatomic) MACloud *cloud;

@property (readwrite, assign, nonatomic) BOOL isLoggingIn;
@property (readwrite, assign, nonatomic) BOOL isLoggedIn;

@property (readwrite, assign, nonatomic) BOOL isDownloadingUserMazes;

@property (readwrite, assign, nonatomic) BOOL isSavingLocalMaze;

@property (readwrite, assign, nonatomic) BOOL isDownloadingHighestRatedMazeSummaries;
@property (readwrite, assign, nonatomic) BOOL isDownloadingNewestMazeSummaries;
@property (readwrite, assign, nonatomic) BOOL isDownloadingYoursMazeSummaries;

@end

@implementation MAWebServices

- (id)initWithReachability: (Reachability *)reachability
{
    self = [super init];
    
    if (self)
    {
        _reachability = reachability;
        
        #if TARGET_IPHONE_SIMULATOR
            NSString *baseSSLURLString = baseSSLURLString = MALocalBaseSSLURLString;
        #else
            NSString *baseSSLURLString = baseSSLURLString = MARemoteBaseSSLURLString;
        #endif
        
        _fatFractal = [[FatFractal alloc] initWithBaseUrl: baseSSLURLString];
        
        _cloud = [[MACloud alloc] init];
        
        _isLoggingIn = NO;
        _isLoggedIn = NO;
        
        _isDownloadingUserMazes = NO;
        
        _isDownloadingHighestRatedMazeSummaries = NO;
        _isDownloadingNewestMazeSummaries = NO;
        _isDownloadingYoursMazeSummaries = NO;
    }
    
    return self;
}

- (id<FFUserProtocol>)loggedInUser
{
    return self.fatFractal.loggedInUser;
}

- (void)autologinWithCompletionHandler: (AutoLoginCompletionHandler)handler
{
    self.isLoggingIn = YES;
    
    if (self.cloud.userName == nil)
    {
        [self getUserCounterWithCompletionHandler: ^(MAUserCounter *userCounter, NSError *error)
         {
             if (error == nil)
             {
                 NSString *userName = [NSString stringWithFormat: @"User%d", userCounter.count];
                 NSString *password = [MAUtilities randomNumericStringWithLength: MARandomPasswordLength];
                 
                 [self loginWithUserName: userName
                                password: password
                       completionHandler: ^(NSError *error)
                  {
                      if (error == nil)
                      {
                          self.cloud.userName = userName;
                          self.cloud.password = password;
                          
                          handler(nil);
                      }
                      else
                      {
                          handler(error);
                      }

                      self.isLoggingIn = NO;
                  }];
             }
             else
             {
                 handler(error);
                 self.isLoggingIn = NO;
             }
         }];
    }
    else
    {
        [self loginWithUserName: self.cloud.userName
                       password: self.cloud.password
              completionHandler: ^(NSError *error)
         {
             if (error == nil)
             {
                 handler(nil);
             }
             else
             {
                 handler(error);
             }
             
             self.isLoggingIn = NO;
         }];
    }
}

- (void)getUserCounterWithCompletionHandler: (GetUserCounterCompletionHandler)handler
{
    [self.fatFractal getObjFromUri: @"/MAUserCounter"
                        onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            MAUserCounter *userCounter = (MAUserCounter *)theObj;
         
            handler(userCounter, nil);
        }
        else
        {
            NSError *error = [self errorWithDescription: @"Unable to get user counter from server."
                                             statusCode: theResponse.statusCode
                                        underlyingError: theErr];

            handler(nil, error);

            [MAUtilities logWithClass: [self class]
                              message: error.localizedDescription
                           parameters: @{@"error" : error}];
        }
    }];
}

- (void)loginWithUserName: (NSString *)userName password: (NSString *)password completionHandler: (LoginCompletionHandler)handler
{
    [self.fatFractal loginWithUserName: userName
                           andPassword: password
                            onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             self.isLoggedIn = YES;
             
             handler(nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to login to server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}


- (void)getTexturesWithCompletionHandler: (GetTexturesCompletionHandler)handler
{
    [self.fatFractal getArrayFromUri: @"/MATexture"
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            NSArray *textures = (NSArray *)theObj;
            handler(textures, nil);
        }
        else
        {
            NSError *error = [self errorWithDescription: @"Unable to get textures from server."
                                             statusCode: theResponse.statusCode
                                        underlyingError: theErr];

            handler(nil, error);
            
            [MAUtilities logWithClass: [self class]
                              message: error.localizedDescription
                           parameters: @{@"error" : error}];
        }
    }];
}

- (void)getSoundsWithCompletionHandler: (GetSoundsCompletionHandler)handler
{
    [self.fatFractal getArrayFromUri: @"/MASound"
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             NSArray *sounds = (NSArray *)theObj;
             handler(sounds, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get sounds from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}


- (void)getUserMazesWithCompletionHandler: (GetUserMazesCompletionHandler)handler
{
    self.isDownloadingUserMazes = YES;
    
    [self.fatFractal getArrayFromUri: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMaze.user/()", self.fatFractal.loggedInUser.userName]
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             NSArray *userMazes = (NSArray *)theObj;
             
             for (MAMaze *maze in userMazes)
             {
                 [self.fatFractal forgetObj: maze];
                 [maze decompressLocationsDataAndWallsData];
             }
             
             handler(userMazes, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get user mazes from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }

         self.isDownloadingUserMazes = NO;
     }];
}

- (void)getMazeWithMazeId: (NSString *)mazeId completionHandler: (GetMazeCompletionHandler)handler
{
    [self.fatFractal getObjFromUri: [NSString stringWithFormat: @"/MAMaze/(mazeId eq '%@')", mazeId]
                        onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            MAMaze *maze = (MAMaze *)theObj;
            [maze decompressLocationsDataAndWallsData];
         
            handler(mazeId, maze, nil);
        }
        else
        {
            NSError *error = [self errorWithDescription: @"Unable to get maze from server."
                                             statusCode: theResponse.statusCode
                                        underlyingError: theErr];

            handler(mazeId, nil, error);
         
            [MAUtilities logWithClass: [self class]
                              message: error.localizedDescription
                           parameters: @{@"error" : error}];
        }
    }];
}


- (void)saveLocalMaze: (MAMaze *)localMaze completionHandler: (SaveMazeCompletionHandler)handler
{
    self.isSavingLocalMaze = YES;
    
    localMaze.modifiedAt = [NSDate date];

    [self.fatFractal getArrayFromUri: [NSString stringWithFormat: @"/MAMaze/(mazeId eq '%@')", localMaze.mazeId]
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            NSArray *serverMazea = (NSArray *)theObj;

            if (serverMazea.count == 0)
            {
                [localMaze compressLocationsAndWallsData];
                
                [self.fatFractal createObj: localMaze
                                     atUri: @"/MAMaze"
                                onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                 {
                     if (theErr == nil && theResponse.statusCode == 201)
                     {
                         handler(nil);
                     }
                     else
                     {
                         NSError *error = [self errorWithDescription: @"Unable to save local maze to server."
                                                          statusCode: theResponse.statusCode
                                                     underlyingError: theErr];
                         
                         handler(error);
                         
                         [MAUtilities logWithClass: [self class]
                                           message: error.localizedDescription
                                        parameters: @{@"error" : error}];
                     }
                     
                     [self.fatFractal forgetObj: localMaze];

                     self.isSavingLocalMaze = NO;
                 }];
            }
            else
            {
                MAMaze *serverMaze = serverMazea[0];
                
                [serverMaze updateWithMaze: localMaze];
                
                [self.fatFractal updateObj: serverMaze
                                onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                 {
                     if (theErr == nil && theResponse.statusCode == 200)
                     {
                         [serverMaze compressLocationsAndWallsData];
                         
                         [self.fatFractal updateBlob: serverMaze.locationsData
                                        withMimeType: @"application/octet-stream"
                                              forObj: serverMaze
                                          memberName: @"locationsData"
                                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                          {
                              if (theErr == nil && theResponse.statusCode == 200)
                              {
                                  [serverMaze compressLocationsAndWallsData];
                                  
                                  [self.fatFractal updateBlob: serverMaze.wallsData
                                                 withMimeType: @"application/octet-stream"
                                                       forObj: serverMaze
                                                   memberName: @"wallsData"
                                                   onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                   {
                                       if (theErr == nil && theResponse.statusCode == 200)
                                       {
                                           handler(nil);
                                       }
                                       else
                                       {
                                           NSError *error = [self errorWithDescription: @"Unable to save local maze walls data to server."
                                                                            statusCode: theResponse.statusCode
                                                                       underlyingError: theErr];
                                           
                                           handler(error);
                                           
                                           [MAUtilities logWithClass: [self class]
                                                             message: error.localizedDescription
                                                          parameters: @{@"error" : error}];
                                       }
                                       
                                       self.isSavingLocalMaze = NO;
                                   }];
                              }
                              else
                              {
                                  NSError *error = [self errorWithDescription: @"Unable to save local maze location data to server."
                                                                   statusCode: theResponse.statusCode
                                                              underlyingError: theErr];
                                  
                                  handler(error);
                                  
                                  self.isSavingLocalMaze = NO;
                                  
                                  [MAUtilities logWithClass: [self class]
                                                    message: error.localizedDescription
                                                 parameters: @{@"error" : error}];
                              }
                          }];
                     }
                     else
                     {
                         NSError *error = [self errorWithDescription: @"Unable to save local maze to server."
                                                          statusCode: theResponse.statusCode
                                                     underlyingError: theErr];
                         
                         handler(error);
                         
                         self.isSavingLocalMaze = NO;
                         
                         [MAUtilities logWithClass: [self class]
                                           message: error.localizedDescription
                                        parameters: @{@"error" : error}];
                     }
                 }];
            }
        }
        else
        {
            NSError *error = [self errorWithDescription: @"Unable to get maze from server."
                                             statusCode: theResponse.statusCode
                                        underlyingError: theErr];
            
            handler(error);
            
            [MAUtilities logWithClass: [self class]
                              message: error.localizedDescription
                           parameters: @{@"error" : error}];
        }
    }];
}


- (void)getHighestRatedMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler
{
    self.isDownloadingHighestRatedMazeSummaries = YES;
    
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/getHighestRatedMazeSummaries?userName=%@", self.fatFractal.loggedInUser.userName];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             NSArray *highestRatedTopMazeItems = (NSArray *)theObj;
             
             handler(highestRatedTopMazeItems, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get highest rated top maze items from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }

         self.isDownloadingHighestRatedMazeSummaries = NO;
     }];
}

- (void)getNewestMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler
{
    self.isDownloadingNewestMazeSummaries = YES;
    
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/getNewestMazeSummaries?userName=%@", self.fatFractal.loggedInUser.userName];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             NSArray *newestTopMazeItems = (NSArray *)theObj;
             
             handler(newestTopMazeItems, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get newest top maze items from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }

         self.isDownloadingNewestMazeSummaries = NO;
     }];
}

- (void)getYoursMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler
{
    self.isDownloadingYoursMazeSummaries = YES;
    
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/getYoursMazeSummaries?userName=%@", self.fatFractal.loggedInUser.userName];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             NSArray *yoursTopMazeItems = (NSArray *)theObj;
             
             handler(yoursTopMazeItems, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get yours top maze items from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }

         self.isDownloadingYoursMazeSummaries = NO;
     }];
}


- (void)saveStartedWithUserName: (NSString *)userName mazeId: (NSString *)mazeId completionHandler: (SaveStartedCompletionHandler)handler
{
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/saveMazeStarted?userName=%@&mazeId=%@", userName, mazeId];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             handler(mazeId, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to save started maze progress to server"
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(mazeId, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}

- (void)saveFoundExitWithUserName: (NSString *)userName mazeId: (NSString *)mazeId mazeName: (NSString *)mazeName completionHandler: (SaveFoundExitCompletionHandler)handler
{
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/saveMazeFoundExit?userName=%@&mazeId=%@", userName, mazeId];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             handler(mazeId, mazeName, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to save found maze exit progress to server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(mazeId, mazeName, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}

- (void)saveMazeRatingWithUserName: (NSString *)userName
                            mazeId: (NSString *)mazeId
                          mazeName: (NSString *)mazeName
                            rating: (float)rating
                 completionHandler: (SaveRatingCompletionHandler)handler
{
    NSString *uri = [NSString stringWithFormat: @"/ff/ext/saveMazeRating?userName=%@&mazeId=%@&rating=%f", userName, mazeId, rating];
    
    [self.fatFractal getArrayFromUri: uri
                          onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             handler(mazeName, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to save maze rating to server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(mazeName, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}


- (void)getLatestVersionWithCompletionHandler: (GetLatestVersionCompletionHandler)handler
{
    [self.fatFractal getObjFromUri: @"/MALatestVersion"
                        onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if (theErr == nil && theResponse.statusCode == 200)
         {
             MALatestVersion *latestVersion = (MALatestVersion *)theObj;
             
             handler(latestVersion, nil);
         }
         else
         {
             NSError *error = [self errorWithDescription: @"Unable to get latest version from server."
                                              statusCode: theResponse.statusCode
                                         underlyingError: theErr];

             handler(nil, error);
             
             [MAUtilities logWithClass: [self class]
                               message: error.localizedDescription
                            parameters: @{@"error" : error}];
         }
     }];
}


- (NSError *)errorWithDescription: (NSString *)description
                       statusCode: (NSInteger)statusCode
                  underlyingError: (NSError *)underlyingError
{
    NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey : description,
                                       MAStatusCodeKey : [NSNumber numberWithInteger: statusCode]} mutableCopy];
    
    if (underlyingError != nil)
    {
        [userInfo setObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    
    NSError *error = [NSError errorWithDomain: @"com.andremuis.mazes" code: 0 userInfo: [userInfo copy]];
    
    return error;
}

@end






















