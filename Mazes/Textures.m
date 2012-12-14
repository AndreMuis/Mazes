//
//  Textures.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Textures.h"

#import "Constants.h"
#import "Texture.h"
#import "Utilities.h"

@implementation Textures

@synthesize loaded;
@synthesize count;
@synthesize maxId;

+ (Textures *)shared
{
	static Textures *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Textures alloc] init];
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
        self->maxId = 0;
	}
	
    return self;
}

- (void)load
{
    self->webServices = [[WebServices alloc] init];
    
    [self->webServices getTexturesWithDelegate: self];
}

- (void)getTexturesSucceeded
{
    self->loaded = YES;
}

- (void)getTexturesFailed
{
    [self performSelector: @selector(load) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
}

- (int)count
{
	return [Texture allObjects].count;
}

- (int)maxId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF.id == %@.@max.id", [Texture allObjects]];
    Texture *texture = [Texture objectWithPredicate: predicate];
    
    return texture.id;
}

- (NSArray *)getTextures
{
	return [Texture allObjects];
}

- (NSArray *)getTexturesSorted
{
    NSFetchRequest *fetchRequest = [Texture fetchRequest];
    NSSortDescriptor *kindSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"kind" ascending: YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObjects: kindSortDescriptor, orderSortDescriptor, nil]];
    
    return [Texture objectsWithFetchRequest: fetchRequest];
}

- (Texture *)getTextureWithId: (int)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %d", id];
    
    return [Texture objectWithPredicate: predicate];
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self getTextures]];
}

@end
