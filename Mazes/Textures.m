//
//  Textures.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Textures.h"

@implementation Textures

@synthesize count;
@synthesize textureIdMax;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        count = 0;
        textureIdMax = 0;
	}
	
    return self;
}

- (int)count
{
    NSArray *textures = [self getTextures];
    
	return textures.count;
}

- (int)textureIdMax
{
    if (textureIdMax == 0)
    {
        NSArray *textures = [self getTextures];

        for (Texture *texture in textures)
        {
            if (texture.id > textureIdMax)
            {
                textureIdMax = texture.id;
            }
        }
    }
    
    return textureIdMax;
}

- (NSArray *)getTextures
{    
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Texture" inManagedObjectContext: [Globals instance].dataAccess.managedObjectContext];   
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity: entity];   
    
    NSError *error = nil;  
    NSArray *textures = [[Globals instance].dataAccess.managedObjectContext executeFetchRequest: request error: &error];   
    
    if (error != nil)
    {
        DLog(@"%@", error);
    }
	
	return textures;
}

- (NSArray *)getTexturesSorted
{
	NSArray *textures = [self getTextures];
	
	NSArray *texturesSorted = [textures sortedArrayUsingComparator: (NSComparator)^(Texture *texture1, Texture *texture2)
							   {
								   int comparisonResult = NSOrderedSame;
								   
								   if (texture1.material == texture2.material)
								   {
									   if (texture1.order < texture2.order)
									   {
										   comparisonResult = NSOrderedAscending;
									   }
									   if (texture1.order == texture2.order)
									   {
										   comparisonResult = NSOrderedSame;
									   }
									   if (texture1.order > texture2.order)
									   {
										   comparisonResult = NSOrderedDescending;
									   }
								   }
								   else if (texture1.material < texture2.material)
								   {
									   comparisonResult = NSOrderedAscending;
								   }
								   else if (texture1.material > texture2.material)
								   {
									   comparisonResult = NSOrderedDescending;
								   }
								   
								   return comparisonResult; 
							   }];
	
	return texturesSorted;
}

- (Texture *)getTextureForId: (int)textureId
{
    Texture *textureRet = nil;
    
    NSArray *textures = [self getTextures]; 
    
    for (Texture *texture in textures)
    {
        if (texture.id == textureId)
        {
            textureRet = texture;
        }
    }
    
    if (textureRet == nil)
    {
        DLog(@"Could not find texture for Id = %d", textureId);
    }
    
	return textureRet;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self getTextures]];
}

@end
