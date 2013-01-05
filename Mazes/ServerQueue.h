//
//  ServerQueue.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServerOperations.h"

@class MAEvent;

@interface ServerQueue : NSObject <MAServerOperationsSaveMazeUserDelegate, MAServerOperationsSaveMazeRatingDelegate>
{
    NSOperationQueue *operationQueue;
    
    MAEvent *enqueueOldestObjectEvent;
    
    NSMutableArray *pendingObjects;
}

+ (ServerQueue *)shared;

- (void)addObject: (NSObject *)object;

- (void)reset;

- (void)enqueueOldestObject;

@end
