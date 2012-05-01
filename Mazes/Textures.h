//
//  Textures.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Texture.h"
#import "XML.h"

@interface Textures : NSObject 
{
	int textureIdMax;
	
	NSMutableDictionary *dictionary;
}

@property (nonatomic) int textureIdMax;

- (id)initWithXML: (xmlDocPtr)doc;

- (void)populateWithXML: (xmlDocPtr)doc;

- (NSArray *)getTextures;

- (NSArray *)getTexturesSorted;

- (Texture *)getTextureForId: (int)textureId;

@end
