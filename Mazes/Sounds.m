//
//  Sounds.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sounds.h"

#import "Constants.h"
#import "Sound.h"

@implementation Sounds

@synthesize loaded;
@synthesize count;

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
        self->loaded = NO;
        self->count = 0;
	}
	
    return self;
}

- (void)load
{
    self->webServices = [[WebServices alloc] init];

    [self->webServices getSoundsWithDelegate: self];
}

- (void)getSoundsSucceeded
{
    self->loaded = YES;
}

- (void)getSoundsFailed
{
    [self performSelector: @selector(load) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
}

- (int)count
{
	return [Sound allObjects].count;
}

- (NSArray *)getSoundsSorted
{
    NSFetchRequest *fetchRequest = [Sound fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    return [Sound objectsWithFetchRequest: fetchRequest];
}

- (Sound *)getSoundWithId: (int)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %d", id];
    
    return [Sound objectWithPredicate: predicate];
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self getSoundsSorted]];
}

@end























