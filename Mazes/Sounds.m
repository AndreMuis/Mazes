//
//  Sounds.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "Sounds.h"

#import "Constants.h"
#import "GameViewController.h"
#import "Sound.h"
#import "Utilities.h"

@implementation Sounds

+ (Sounds *)shared
{
	static Sounds *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Sounds alloc] init];
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
        
        _count = 0;
	}
	
    return self;
}

- (void)download
{
    [self->operationQueue addOperation: [[ServerOperations shared] getSoundsOperationWithDelegate: self]];
}

- (void)serverOperationsGetSounds: (NSError *)error
{
    if (error == nil)
    {
        [[GameViewController shared] setup];
    }
    else
    {
        [self performSelector: @selector(download) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

- (int)count
{
    return [Sound MR_findAll].count;
}

- (NSArray *)sortedByName
{
    return [Sound MR_findAllSortedBy: @"name" ascending: YES];
}

- (Sound *)soundWithId: (int)id
{
    Sound *soundRet = [Sound MR_findFirstByAttribute: @"id" withValue: [NSNumber numberWithInt: id]];
    
    if (soundRet == nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to find sound with id: %d", id];
    }
    
    return soundRet;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self sortedByName]];
}

@end























