//
//  MATextureManager.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATextureManager.h"

#import "MATexture.h"
#import "MAUtilities.h"

@interface  MATextureManager ()

@property (strong, nonatomic, readonly) NSArray *textures;

@end

@implementation MATextureManager

- (id)initWithTextures: (NSArray *)textures
{
    self = [super init];
	
	if (self)
	{
        _textures = textures;
	}
	
    return self;
}

- (int)count
{
    return self.textures.count;
}

- (NSArray *)all
{
	return self.textures;
}

- (NSArray *)sortedByKindThenOrder
{
    NSSortDescriptor *kindSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"kind" ascending: YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];

    NSArray *sortedArray = [self.textures sortedArrayUsingDescriptors: [NSArray arrayWithObjects: kindSortDescriptor, orderSortDescriptor, nil]];

    return sortedArray;
}

- (MATexture *)textureWithTextureId: (NSString *)textureId
{
    MATexture *texture = nil;
    
    NSUInteger index = [self.textures indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop)
                        {
                            return [((MATexture *)obj).textureId isEqualToString: textureId];
                        }];
    
    if (index != NSNotFound)
    {
        texture = [self.textures objectAtIndex: index];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Unable to find texture with textureId: %d", textureId];
    }
    
    return texture;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"textures = %@>", self.textures];
    
    return desc;
}

@end













