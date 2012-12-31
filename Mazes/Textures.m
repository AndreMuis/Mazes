//
//  Textures.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "Textures.h"

#import "Constants.h"
#import "GameViewController.h"
#import "Texture.h"
#import "Utilities.h"

@implementation Textures

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
        self->operationQueue = [[NSOperationQueue alloc] init];
        
        _count = 0;
        _maxId = 0;
	}
	
    return self;
}

- (void)download
{
    [self->operationQueue addOperation: [[ServerOperations shared] getTexturesOperationWithDelegate: self]];
}

- (void)serverOperationsGetTextures: (NSError *)error
{
    if (error == nil)
    {
        [[GameViewController shared] setup];
    }
    else
    {
        [self performSelector: @selector(download) withObject: self afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

- (int)count
{
	return [Texture MR_findAll].count;
}

- (int)maxId
{
    Texture *texture = [Texture MR_findFirstOrderedByAttribute: @"id" ascending: NO];
    
    if (texture == nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to determine max id. No textures found."];
    }

    return texture.id;
}

- (NSArray *)all
{
	return [Texture MR_findAll];
}

- (NSArray *)sortedByKindThenOrder
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"Texture"];
    NSSortDescriptor *kindSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"kind" ascending: YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObjects: kindSortDescriptor, orderSortDescriptor, nil]];
    
    return [Texture MR_executeFetchRequest: fetchRequest];
}

- (Texture *)textureWithId: (int)id
{
    Texture *textureRet = [Texture MR_findFirstByAttribute: @"id" withValue: [NSNumber numberWithInt: id]];
    
    if (textureRet == nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to find texture with id: %d", id];
    }
    
    return textureRet;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self all]];
}

@end













