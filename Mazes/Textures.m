//
//  Textures.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Textures.h"

@implementation Textures

@synthesize textureIdMax;

- (id)initWithXML: (xmlDocPtr)doc
{
    self = [super init];
	
    if (self)
	{
		dictionary = [[NSMutableDictionary alloc] init];

		[self populateWithXML: doc];
	}
	
    return self;
}

- (void)populateWithXML: (xmlDocPtr)doc
{
	textureIdMax = 0;
	
	xmlNodePtr node = [XML getNodesFromDoc: doc XPath: "/Response/Textures/Texture"];

	xmlNodePtr nodeCurr;
	for (nodeCurr = node; nodeCurr; nodeCurr = nodeCurr->next)
	{
		Texture *texture = [[Texture alloc] init];
	
		texture.textureId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "TextureId"] intValue];
		texture.name = [XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Name"];
		texture.width = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Width"] intValue];
		texture.height = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Height"] intValue];
		texture.repeats = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Repeats"] intValue];
		texture.type = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Type"] intValue];
		texture.order = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Order"] intValue];			
		
		if (texture.textureId > textureIdMax)
			textureIdMax = texture.textureId;

		[dictionary setObject: texture forKey: [NSNumber numberWithInt: texture.textureId]];
	}

	xmlFreeNodeList(node);
}

- (NSArray *)getTextures
{
	NSArray *textures = [dictionary allValues];

	return textures;
}

- (NSArray *)getTexturesSorted
{
	NSArray *textures = [dictionary allValues];
	
	NSArray *texturesSorted = [textures sortedArrayUsingComparator: (NSComparator)^(Texture *texture1, Texture *texture2)
							   {
								   int comparisonResult = NSOrderedSame;
								   
								   if (texture1.type == texture2.type)
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
								   else if (texture1.type < texture2.type)
								   {
									   comparisonResult = NSOrderedAscending;
								   }
								   else if (texture1.type > texture2.type)
								   {
									   comparisonResult = NSOrderedDescending;
								   }
								   
								   return comparisonResult; 
							   }];
	
	return texturesSorted;
}

- (Texture *)getTextureForId: (int)textureId
{
	return [dictionary objectForKey: [NSNumber numberWithInt: textureId]];
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", dictionary];
}

@end
