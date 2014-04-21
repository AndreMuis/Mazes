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
        
        _userMazes = [NSMutableArray array];
        
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

- (void)downloadTopMazeSummariesWithType: (MATopMazeSummariesType)topMazeSummariesType
                       completionHandler: (DownloadTopMazeSummariesCompletionHandler)completionHandler
{
    switch (topMazeSummariesType)
    {
        case MATopMazeSummariesHighestRated:
        {
            [self.webServices getHighestRatedMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
             {
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
            break;
        }
            
        case MATopMazeSummariesNewest:
        {
            [self.webServices getNewestMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
             {
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
            break;
        }
            
        case MATopMazeSummariesYours:
        {
            [self.webServices getYoursMazeSummariesWithCompletionHandler: ^(NSArray *topMazeSummaries, NSError *error)
             {
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
            break;
        }
            
        default:
            [MAUtilities logWithClass: [self class] format: @"topMazeSummariesType set to an illegal value: %d", topMazeSummariesType];
            break;
    }
}

- (BOOL)isDownloadingTopMazeSummariesOfType: (MATopMazeSummariesType)topMazeSummariesType
{
    switch (topMazeSummariesType)
    {
        case MATopMazeSummariesHighestRated:
            return self.webServices.isDownloadingHighestRatedMazeSummaries;;
            break;
            
        case MATopMazeSummariesNewest:
            return self.webServices.isDownloadingNewestMazeSummaries;
            break;
            
        case MATopMazeSummariesYours:
            return self.webServices.isDownloadingYoursMazeSummaries;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"topMazeSummariesType set to an illegal value: %d", topMazeSummariesType];
            return NO;
            break;
    }
}

- (NSArray *)topMazeSummariesOfType: (MATopMazeSummariesType)topMazeSummariesType
{
    switch (topMazeSummariesType)
    {
        case MATopMazeSummariesHighestRated:
            return self.highestRatedMazeSummaries;
            break;
            
        case MATopMazeSummariesNewest:
            return self.newestMazeSummaries;
            break;
            
        case MATopMazeSummariesYours:
            return self.yoursMazeSummaries;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"topMazeSummariesType set to an illegal value: %d", topMazeSummariesType];
            return nil;
            break;
    }
}

@end





















