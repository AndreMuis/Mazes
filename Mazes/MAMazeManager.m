//
//  MAMazeManager.m
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMazeManager.h"

#import "MAConstants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MAMaze.h"
#import "MATopMazeItem.h"
#import "MAUserManager.h"
#import "MAUser.h"
#import "MAUtilities.h"

@interface MAMazeManager ()

@property (strong, nonatomic, readonly) MAEvent *getHighestRatedMazesEvent;
@property (strong, nonatomic, readonly) MAEvent *getNewestMazesEvent;
@property (strong, nonatomic, readonly) MAEvent *getYoursMazesEvent;

@end

@implementation MAMazeManager

+ (MAMazeManager *)shared
{
	static MAMazeManager *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MAMazeManager alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _highestRatedTopMazeItems = nil;
        _newestTopMazeItems = nil;
        _yoursTopMazeItems = nil;
        
        _isDownloadingHighestRatedMazes = NO;
        _isDownloadingNewestMazes = NO;
        _isDownloadingYoursMazes = NO;

        _getHighestRatedMazesEvent = [[MAEvent alloc] initWithTarget: self
                                                              action: @selector(getHighestRatedMazesWithCompletionHandler:)
                                                        intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                             repeats: NO];
        
        _getNewestMazesEvent = [[MAEvent alloc] initWithTarget: self
                                                        action: @selector(getNewestMazesWithCompletionHandler:)
                                                  intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                       repeats: NO];

        _getYoursMazesEvent = [[MAEvent alloc] initWithTarget: self
                                                       action: @selector(getYoursMazesWithCompletionHandler:)
                                                 intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                      repeats: NO];
	}
	
    return self;
}

- (void)getHighestRatedMazesWithCompletionHandler: (DownloadCompletionHandler)handler
{
    _isDownloadingHighestRatedMazes = YES;
    
    [PFCloud callFunctionInBackground: @"getHighestRatedMazes"
                       withParameters: @{@"userObjectId" : [MAUserManager shared].currentUser.objectId}
                                block: ^(id object, NSError *error)
     {
         if (error == nil)
         {
             NSArray *dictionaries = (NSArray *)object;
             
             self.highestRatedTopMazeItems = [self topMazeItemsWithDictionaries: dictionaries];

             _isDownloadingHighestRatedMazes = NO;
         }
         else
         {
             [MAUtilities logWithClass: [self class] format: @"Unable to get highest rated mazes from server. Error: %@", error];
         
             self.getHighestRatedMazesEvent.object = handler;
             [[MAEvents shared] addEvent: self.getHighestRatedMazesEvent];
         }
     }];
}

- (void)getNewestMazesWithCompletionHandler: (DownloadCompletionHandler)handler
{
    _isDownloadingNewestMazes = YES;
    
    [PFCloud callFunctionInBackground: @"getNewestMazes"
                       withParameters: @{@"userObjectId" : [MAUserManager shared].currentUser.objectId}
                                block: ^(id object, NSError *error)
     {
         if (error == nil)
         {
             NSArray *dictionaries = (NSArray *)object;
             
             self.newestTopMazeItems = [self topMazeItemsWithDictionaries: dictionaries];
             
             _isDownloadingNewestMazes = NO;
         }
         else
         {
             [MAUtilities logWithClass: [self class] format: @"Unable to get newest mazes from server. Error: %@", error];
             
             self.getNewestMazesEvent.object = handler;
             [[MAEvents shared] addEvent: self.getNewestMazesEvent];
         }
     }];
}

- (void)getYoursMazesWithCompletionHandler: (DownloadCompletionHandler)handler
{
    _isDownloadingYoursMazes = YES;
    
    [PFCloud callFunctionInBackground: @"getCurrentUserMazes"
                       withParameters: @{@"userObjectId" : [MAUserManager shared].currentUser.objectId}
                                block: ^(id object, NSError *error)
     {
         if (error == nil)
         {
             NSArray *dictionaries = (NSArray *)object;
             
             self.yoursTopMazeItems = [self topMazeItemsWithDictionaries: dictionaries];
             
             _isDownloadingYoursMazes = NO;
         }
         else
         {
             [MAUtilities logWithClass: [self class] format: @"Unable to get current user's mazes from server. Error: %@", error];
             
             self.getYoursMazesEvent.object = handler;
             [[MAEvents shared] addEvent: self.getYoursMazesEvent];
         }
     }];
}

- (NSArray *)topMazeItemsWithDictionaries: (NSArray *)dictionaries
{
    NSMutableArray *topMazeItems = [NSMutableArray array];

    for (NSDictionary *dictionary in dictionaries)
    {
        MATopMazeItem *topMazeItem = [[MATopMazeItem alloc] initWithDictionary: dictionary];
        
        [topMazeItems addObject: topMazeItem];
    }
    
    return topMazeItems;
}

@end















