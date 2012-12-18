//
//  Maze.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Maze.h"
#import "Locations.h"

@implementation Maze

@synthesize mazeId;
@synthesize name;
@synthesize rows;
@synthesize columns;
@synthesize isPublic;
@synthesize backgroundSoundId; 
@synthesize wallTextureId;
@synthesize floorTextureId;
@synthesize ceilingTextureId; 

@synthesize locations;

- (id)init
{
	self = [super init];
	
    if (self)
	{
		locations = [[Locations alloc] init];
		
		[self reset];
	}
	
	return self;
}

/*
- (void)populateFromXML: (xmlDocPtr) doc
{
	xmlNodePtr rootNode = [XML getRootNodeDoc: doc];
	
	self.mazeId = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/MazeId"] intValue];
	self.name = [XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/Name"];
	self.rows = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/Rows"] intValue];
	self.columns = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/Columns"] intValue];
	self.isPublic = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/IsPublic"] isEqualToString: @"True"] == YES ? YES : NO;
	self.backgroundSoundId = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/BackgroundSoundId"] intValue];
	self.wallTextureId = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/WallTextureId"] intValue];
	self.floorTextureId = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/FloorTextureId"] intValue];
	self.ceilingTextureId = [[XML getNodeValueFromDoc: doc Node: rootNode XPath: "/Response/Maze/CeilingTextureId"] intValue];
}
*/

- (void)reset
{
	self.mazeId = 0;
	self.name = @"";
	self.rows = 0;
	self.columns = 0;
	self.isPublic = NO;
	self.backgroundSoundId = 0;
	self.wallTextureId = 38; // blue
	self.floorTextureId = 33; // white
	self.ceilingTextureId = 33; // white
	
	[locations reset];
}

- (void)setWallTextureIdWithNumber: (NSNumber *)textureId
{
	self.WallTextureId = [textureId intValue];
}

- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId
{
	self.FloorTextureId = [textureId intValue];
}

- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId
{
	self.CeilingTextureId = [textureId intValue];
}
 
- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"mazeId = %d", self.mazeId];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, rows = %d", desc, self.rows];
    desc = [NSString stringWithFormat: @"%@, columns = %d", desc, self.columns];
    desc = [NSString stringWithFormat: @"%@, isPublic = %d", desc, self.isPublic];
    desc = [NSString stringWithFormat: @"%@, backgroundSoundId = %d", desc, self.backgroundSoundId];
    desc = [NSString stringWithFormat: @"%@, wallTextureId = %d", desc, self.wallTextureId];
    desc = [NSString stringWithFormat: @"%@, floorTextureId = %d", desc, self.floorTextureId];
    desc = [NSString stringWithFormat: @"%@, ceilingTextureId = %d", desc, self.ceilingTextureId];
    
    return desc;
}

@end





