//
//  Textures.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Globals.h"
#import "DataAccess.h"
#import "Texture.h"

@interface Textures : NSObject 
{
    int count;
	int textureIdMax;
}

@property (nonatomic) int count;
@property (nonatomic) int textureIdMax;

- (NSArray *)getTextures;

- (NSArray *)getTexturesSorted;

- (Texture *)getTextureForId: (int)textureId;

@end
