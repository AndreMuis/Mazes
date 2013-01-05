//
//  ServerQueue
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "ServerQueue.h"

#import "Constants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MazeUser.h"
#import "Rating.h"
#import "Utilities.h"

@implementation ServerQueue

+ (ServerQueue *)shared
{
	static ServerQueue *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[ServerQueue alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        self->operationQueue = [[NSOperationQueue alloc] init];
        
        self->enqueueOldestObjectEvent = [[MAEvent alloc] initWithTarget: self
                                                                  action: @selector(enqueueOldestObject)
                                                            intervalSecs: [Constants shared].serverRetryDelaySecs
                                                                 repeats: NO];
        
        self->pendingObjects = [[NSMutableArray alloc] init];
	}
    
    return self;
}

- (void)addObject: (NSObject *)object
{
    MazeUser *mazeUser = nil;
    Rating *rating = nil;
    
    if ([object isKindOfClass: [MazeUser class]] == YES)
    {
        mazeUser = (MazeUser *)object;
    }
    else if ([object isKindOfClass: [Rating class]] == YES)
    {
        rating = (Rating *)object;
    }
    else
    {
        [Utilities logWithClass: [self class] format: @"Instances of class %@ cannot be queued.", [object class]];
    }

    NSArray *objects = [NSArray arrayWithArray: self->pendingObjects];
    
    for (NSObject *someObject in objects)
    {
        if ([someObject isKindOfClass: [MazeUser class]] == YES && mazeUser != nil)
        {
            MazeUser *someMazeUser = (MazeUser *)someObject;
            
            if (someMazeUser.id = mazeUser.id)
            {
                [self->pendingObjects removeObject: someObject];
            }
        }
        else if ([someObject isKindOfClass: [Rating class]] == YES && rating != nil)
        {
            Rating *someRating = (Rating *)someObject;
            
            if (someRating.mazeId == rating.mazeId && someRating.userId == rating.userId)
            {
                [self->pendingObjects removeObject: someObject];
            }
        }
    }
    
    [self reset];
    
    [self->pendingObjects insertObject: object atIndex: 0];
    
    [self enqueueOldestObject];
}

- (void)reset
{
    if ([[MAEvents shared] hasEvent: self->enqueueOldestObjectEvent] == YES)
    {
        [[MAEvents shared] removeEvent: self->enqueueOldestObjectEvent];
    }
    
    [self->operationQueue cancelAllOperations];
}

- (void)enqueueOldestObject
{
    NSObject *object = [self->pendingObjects lastObject];
    
    if ([object isKindOfClass: [MazeUser class]] == YES)
    {
        MazeUser *mazeUser = (MazeUser *)object;
        
        [self->operationQueue addOperation: [[ServerOperations shared] saveMazeUserOperationWithDelegate: self mazeUser: mazeUser]];
    }
    else if ([object isKindOfClass: [Rating class]] == YES)
    {
        Rating *rating = (Rating *)object;
        
        [self->operationQueue addOperation: [[ServerOperations shared] saveMazeRatingOperationWithDelegate: self rating: rating]];
    }
}

- (void)serverOperationsSaveMazeUserWithError: (NSError *)error
{
    if (error == nil)
    {
        [self->pendingObjects removeLastObject];
        
        if (self->pendingObjects.count > 0)
        {
            [self enqueueOldestObject];
        }
    }
    else
    {
        [[MAEvents shared] addEvent: self->enqueueOldestObjectEvent];
    }
}

- (void)serverOperationsSaveRatingWithError: (NSError *)error
{
    if (error == nil)
    {
        [self->pendingObjects removeLastObject];
        
        if (self->pendingObjects.count > 0)
        {
            [self enqueueOldestObject];
        }
    }
    else
    {
        [[MAEvents shared] addEvent: self->enqueueOldestObjectEvent];
    }
}

@end

















