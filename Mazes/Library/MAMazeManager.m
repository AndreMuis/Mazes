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
#import "MAMazeSummary.h"
#import "MASound.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MAUtilities.h"
#import "MAWebServices.h"

@interface MAMazeManager ()

@property (readonly, strong, nonatomic) NSMutableArray *userMazes;
@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) NSArray *highestRatedMazeSummaries;
@property (readonly, strong, nonatomic) NSArray *newestMazeSummaries;
@property (readonly, strong, nonatomic) NSArray *yoursMazeSummaries;

@end

@implementation MAMazeManager

- (id)initWithWebServices: (MAWebServices *)webServices
{
    self = [super init];
	
	if (self)
	{
        _webServices = webServices;
        
        _maze = nil;
        
        _userMazes = nil;
        
        _isFirstUserMazeSizeChosen = NO;
        
        _highestRatedMazeSummaries = nil;
        _newestMazeSummaries = nil;
        _yoursMazeSummaries = nil;
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

- (void)downloadTopMazeSummariesWithType: (MATopMazesType)topMazesType
                       completionHandler: (DownloadTopMazeSummariesCompletionHandler)completionHandler
{
    switch (topMazesType)
    {
        case MATopMazesHighestRated:
            if (self.webServices.isDownloadingHighestRatedMazeSummaries == NO)
            {
                NSLog(@"downloading highest rated");
                
                [self.webServices getHighestRatedMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
                 {
                     NSLog(@"downloaded highest rated");
                     
                     if (error == nil)
                     {
                         _highestRatedMazeSummaries = topMazeSummaries;
                         completionHandler(nil);
                     }
                     else
                     {
                         completionHandler(error);
                     }
                 }];
            }
            break;
            
        case MATopMazesNewest:
            if (self.webServices.isDownloadingNewestMazeSummaries == NO)
            {
                NSLog(@"downloading newest");
                
                [self.webServices getNewestMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
                 {
                     NSLog(@"downloaded newest");
                     
                     if (error == nil)
                     {
                         _newestMazeSummaries = topMazeSummaries;
                         completionHandler(nil);
                     }
                     else
                     {
                         completionHandler(error);
                     }
                 }];
            }
            break;
        
        case MATopMazesYours:
            if (self.webServices.isDownloadingYoursMazeSummaries == NO)
            {
                NSLog(@"downloading yours");
                
                [self.webServices getYoursMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
                 {
                     NSLog(@"downloaded yours");
                     
                     if (error == nil)
                     {
                         _yoursMazeSummaries  = topMazeSummaries;
                         completionHandler(nil);
                     }
                     else
                     {
                         completionHandler(error);
                     }
                 }];
            }
            break;

        default:
            [MAUtilities logWithClass: [self class] format: @"topMazesType set to an illegal value: %d", topMazesType];
            break;
    }
}

- (NSArray *)topMazeSummariesOfType: (MATopMazesType)topMazesType
{
    switch (topMazesType)
    {
        case MATopMazesHighestRated:
            return self.highestRatedMazeSummaries;
            break;
            
        case MATopMazesNewest:
            return self.newestMazeSummaries;
            break;
            
        case MATopMazesYours:
            return self.yoursMazeSummaries;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"topMazesType set to an illegal value: %d", topMazesType];
            return nil;
            break;
    }
}

@end





















