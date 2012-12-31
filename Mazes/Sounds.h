//
//  Sounds.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"

#import "ServerOperations.h"

@class Sound;

@interface Sounds : NSObject <NSFetchedResultsControllerDelegate, MAServerOperationsGetSoundsDelegate>
{
    NSOperationQueue *operationQueue;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (assign, nonatomic) int count;

+ (Sounds *)shared;

- (void)download;

- (NSArray *)sortedByName;

- (Sound *)soundWithId: (int)id;

@end
