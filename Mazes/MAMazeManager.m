//
//  MAMazeManager.m
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMazeManager.h"

#import "MAConstants.h"
#import "MAMaze.h"
#import "MAMazeProgress.h"
#import "MAMazeRating.h"
#import "MASound.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazeItem.h"
#import "MAUtilities.h"

@interface MAMazeManager ()

@property (readonly, strong, nonatomic) AMFatFractal *amFatFractal;

@property (readonly, strong, nonatomic) NSMutableArray *userMazes;

@property (strong, nonatomic) AMRequest *getUserMazesRequest;
@property (strong, nonatomic) AMRequest *saveMazeRequest;

@property (strong, nonatomic) AMRequest *getHighestRatedRequest;
@property (strong, nonatomic) AMRequest *getHighestRatedProgressRequest;
@property (strong, nonatomic) AMRequest *getHighestRatedRatingsRequest;

@property (strong, nonatomic) AMRequest *getNewestRequest;
@property (strong, nonatomic) AMRequest *getNewestProgressRequest;
@property (strong, nonatomic) AMRequest *getNewestRatingsRequest;

@property (strong, nonatomic) AMRequest *getYoursRequest;
@property (strong, nonatomic) AMRequest *getYoursProgressRequest;
@property (strong, nonatomic) AMRequest *getYoursRatingsRequest;

@end

@implementation MAMazeManager

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal
{
    self = [super init];
	
	if (self)
	{
        _amFatFractal = amFatFractal;
        
        _userMazes = nil;
        
        _isFirstUserMazeSizeChosen = NO;
        
        _highestRatedTopMazeItems = nil;
        _newestTopMazeItems = nil;
        _yoursTopMazeItems = nil;

        _getHighestRatedRequest = nil;
        _getHighestRatedProgressRequest = nil;
        _getHighestRatedRatingsRequest = nil;
        
        _getNewestRequest = nil;
        _getNewestProgressRequest = nil;
        _getNewestRatingsRequest = nil;
        
        _getYoursRequest = nil;
        _getYoursProgressRequest = nil;
        _getYoursRatingsRequest = nil;
        
        _getUserMazesRequest = nil;
        _saveMazeRequest = nil;
	}
	
    return self;
}

- (NSArray *)allUserMazes
{
    return self.userMazes;
}

- (void)addMaze: (MAMaze *)maze
{
    [self.userMazes addObject: maze];
}

- (MAMaze *)firstUserMaze
{
    return self.userMazes[0];
}

- (BOOL)isDownloadingHighestRatedMazes
{
    return (self.getHighestRatedRequest != nil || self.getHighestRatedProgressRequest != nil || self.getHighestRatedRatingsRequest);
}

- (BOOL)isDownloadingNewestMazes
{
    return (self.getNewestRequest != nil || self.getNewestProgressRequest || self.getNewestRatingsRequest);
}

- (BOOL)isDownloadingYoursMazes
{
    return (self.getYoursRequest != nil || self.getYoursProgressRequest != nil || self.getYoursRatingsRequest != nil);
}

- (void)getUserMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler
{
    self.getUserMazesRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMaze.user/()", self.currentUser.userName]
                                                 completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                {
                                    if (theErr == nil && theResponse.statusCode == 200)
                                    {
                                        _userMazes = [NSMutableArray arrayWithArray: (NSArray *)theObj];
                                       
                                        for (MAMaze *maze in self.userMazes)
                                        {
                                            [maze decompressLocationsDataAndWallsData];
                                        }

                                        handler();
                                    }
                                }];
}

- (void)cancelGetUserMazes
{
    [self.amFatFractal amCancelRequest: self.getUserMazesRequest];
}

- (void)saveMaze: (MAMaze *)maze completionHandler: (SaveMazeCompletionHandler)handler
{
    if (maze.mazeId == nil)
    {
        maze.mazeId = [MAUtilities uuid];

        [maze compressLocationsAndWallsData];
        
        self.saveMazeRequest = [self.amFatFractal amCreateObject: maze
                                                           atURI: @"/MAMaze"
                                               completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                {
                                    if (theErr == nil && theResponse.statusCode == 201)
                                    {
                                        handler();
                                    }
                                }];
    }
    else
    {
        self.saveMazeRequest = [self.amFatFractal amUpdateObject: maze
                                               completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                {
                                    if (theErr == nil && theResponse.statusCode == 200)
                                    {
                                        [maze compressLocationsAndWallsData];

                                        [self.amFatFractal updateBlob: maze.locationsData
                                                         withMimeType: @"application/octet-stream"
                                                               forObj: maze
                                                           memberName: @"locationsData"
                                                           onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                         {
                                             if (theErr == nil && theResponse.statusCode == 200)
                                             {
                                                 [maze compressLocationsAndWallsData];
                                                 
                                                 [self.amFatFractal updateBlob: maze.wallsData
                                                                  withMimeType: @"application/octet-stream"
                                                                        forObj: maze
                                                                    memberName: @"wallsData"
                                                                    onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                                                  {
                                                      handler();
                                                  }];
                                             }
                                         }];
                                    }
                                }];
    }
}

- (void)cancelSaveMaze
{
    [self.amFatFractal amCancelRequest: self.saveMazeRequest];
}

- (void)getHighestRatedMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler
{
    self.getHighestRatedRequest = [self.amFatFractal amGetArrayFromURI: @"/MAMaze/(public eq true)?sort=averageRating desc&count=100&start=0"
                                                     completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            NSArray *highestRatedMazes = (NSArray *)theObj;

            self.getHighestRatedProgressRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeProgress.user/()", self.currentUser.userName]
                                                                    completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
            {
                if (theErr == nil && theResponse.statusCode == 200)
                {
                    NSArray *mazeProgresses = (NSArray *)theObj;
                   
                    self.getHighestRatedRatingsRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeRating.user/()", self.currentUser.userName]
                                                                            completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                    {
                        if (theErr == nil && theResponse.statusCode == 200)
                        {
                            NSArray *mazeRatings = (NSArray *)theObj;
                          
                            _highestRatedTopMazeItems = [self topMazeItemsWithMazes: highestRatedMazes
                                                                     mazeProgresses: mazeProgresses
                                                                        mazeRatings: mazeRatings];
                          
                            handler();
                          
                            self.getHighestRatedRequest = nil;
                            self.getHighestRatedProgressRequest = nil;
                            self.getHighestRatedRatingsRequest = nil;
                        }
                        else
                        {
                            [MAUtilities logWithClass: [self class]
                                               format: @"Unable to get maze progress from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                        }
                    }];
                   
                }
                else
                {
                    [MAUtilities logWithClass: [self class]
                                       format: @"Unable to get maze rating from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                }
            }];
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                               format: @"Unable to get highest rated mazes from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
        }
    }];
}

- (void)getNewestMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler
{
    self.getNewestProgressRequest = [self.amFatFractal amGetArrayFromURI: @"/MAMaze/(public eq true)?sort=modifiedAt desc&count=100&start=0"
                                                       completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            NSArray *newestMazes = (NSArray *)theObj;
           
            self.getNewestProgressRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeProgress.user/()", self.currentUser.userName]
                                                               completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
            {
                if (theErr == nil && theResponse.statusCode == 200)
                {
                    NSArray *mazeProgresses = (NSArray *)theObj;
         
                    self.getNewestRatingsRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeRating.user/()", self.currentUser.userName]
                                                                      completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                    {
                        if (theErr == nil && theResponse.statusCode == 200)
                        {
                            NSArray *mazeRatings = (NSArray *)theObj;
                
                            _newestTopMazeItems = [self topMazeItemsWithMazes: newestMazes
                                                               mazeProgresses: mazeProgresses
                                                                  mazeRatings: mazeRatings];
                
                            handler();
                
                            self.getNewestRequest = nil;
                            self.getNewestProgressRequest = nil;
                            self.getNewestRatingsRequest = nil;
                        }
                        else
                        {
                            [MAUtilities logWithClass: [self class]
                                               format: @"Unable to get maze progress from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                        }
                    }];
                }
                else
                {
                    [MAUtilities logWithClass: [self class]
                                       format: @"Unable to get maze rating from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                }
            }];
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                               format: @"Unable to get newest mazes from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
        }
    }];
}

- (void)getYoursMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler
{
    self.getYoursRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMaze.user/()?sort=name asc", self.currentUser.userName]
                                              completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            NSArray *yoursMazes = (NSArray *)theObj;
         
            self.getYoursProgressRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeProgress.user/()", self.currentUser.userName]
                                                              completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
            {
                if (theErr == nil && theResponse.statusCode == 200)
                {
                    NSArray *mazeProgresses = (NSArray *)theObj;
                      
                    self.getYoursRatingsRequest = [self.amFatFractal amGetArrayFromURI: [NSString stringWithFormat: @"/FFUser/(userName eq '%@')/BackReferences.MAMazeRating.user/()", self.currentUser.userName]
                                                                     completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                    {
                        if (theErr == nil && theResponse.statusCode == 200)
                        {
                            NSArray *mazeRatings = (NSArray *)theObj;
                              
                            _yoursTopMazeItems = [self topMazeItemsWithMazes: yoursMazes
                                                              mazeProgresses: mazeProgresses
                                                                 mazeRatings: mazeRatings];
                              
                            handler();
                              
                            self.getYoursRequest = nil;
                            self.getYoursProgressRequest = nil;
                            self.getYoursRatingsRequest = nil;
                        }
                        else
                        {
                            [MAUtilities logWithClass: [self class]
                                               format: @"Unable to get maze progress from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                        }
                    }];
                }
                else
                {
                    [MAUtilities logWithClass: [self class]
                                       format: @"Unable to get maze rating from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
                }
            }];
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                               format: @"Unable to get yours mazes from server. StatusCode: %d. Error: %@", theResponse.statusCode, theObj];
        }
    }];
}

- (void)cancelDownloads
{
    if (self.getHighestRatedRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getHighestRatedRequest];
        self.getHighestRatedRequest = nil;
    }
    
    if (self.getHighestRatedProgressRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getHighestRatedProgressRequest];
        self.getHighestRatedProgressRequest = nil;
    }

    if (self.getHighestRatedRatingsRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getHighestRatedRatingsRequest];
        self.getHighestRatedRatingsRequest = nil;
    }
    

    if (self.getNewestRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getNewestRequest];
        self.getNewestRequest = nil;
    }
    
    if (self.getNewestProgressRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getNewestProgressRequest];
        self.getNewestProgressRequest = nil;
    }
    
    if (self.getNewestRatingsRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getNewestRatingsRequest];
        self.getNewestRatingsRequest = nil;
    }
    
    
    if (self.getYoursRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getYoursRequest];
        self.getYoursRequest = nil;
    }

    if (self.getYoursProgressRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getYoursProgressRequest];
        self.getYoursProgressRequest = nil;
    }

    if (self.getYoursRatingsRequest != nil)
    {
        [self.amFatFractal amCancelRequest: self.getYoursRatingsRequest];
        self.getYoursRatingsRequest = nil;
    }
}

- (NSArray *)topMazeItemsWithMazes: (NSArray *)mazes mazeProgresses: (NSArray *)mazeProgresses mazeRatings: (NSArray *)mazeRatings
{
    NSMutableArray *topMazeItems = [NSMutableArray array];
    
    for (MAMaze *maze in mazes)
    {
        MATopMazeItem *topMazeItem = [[MATopMazeItem alloc] init];
        
        topMazeItem.maze = maze;
        topMazeItem.mazeName = maze.name;
        topMazeItem.averageRating = maze.averageRating;
        topMazeItem.ratingCount = maze.ratingCount;
        topMazeItem.modifiedAt = maze.modifiedAt;

        for (MAMazeProgress *mazeProgress in mazeProgresses)
        {
            if (mazeProgress.user == self.currentUser && mazeProgress.maze == maze)
            {
                topMazeItem.userStarted = mazeProgress.started;
            }
        }

        for (MAMazeRating *mazeRating in mazeRatings)
        {
            if (mazeRating.maze == maze && mazeRating.user == self.currentUser)
            {
                topMazeItem.userRating = mazeRating.userRating;
            }
        }
        
        [topMazeItems addObject: topMazeItem];
    }

    return topMazeItems;
}

@end















