//
//  Location.m
//  iPad_Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize mazeId; 
@synthesize x;
@synthesize y; 
@synthesize direction; 
@synthesize wallNorth; 
@synthesize wallWest;
@synthesize type;
@synthesize message; 
@synthesize teleportId; 
@synthesize teleportX;
@synthesize teleportY; 
@synthesize wallNorthTextureId; 
@synthesize wallWestTextureId;
@synthesize floorTextureId;
@synthesize ceilingTextureId; 
@synthesize visited; 
@synthesize wallNorthHit; 
@synthesize wallWestHit;

- (id)init
{
    self = [super init];
	
    if (self)
	{
		mazeId = 0;
		x = 0;
		y = 0;
		direction = 0;
		wallNorth = [Constants shared].WallType.Solid;
		wallWest = [Constants shared].WallType.Solid;
		type = [Constants shared].LocationType.DoNothing;
		message = @"";
		teleportId = 0;
		teleportX = 0;
		teleportY = 0;
		wallNorthTextureId = 0; 
		wallWestTextureId = 0;
		floorTextureId = 0;
		ceilingTextureId = 0;
		visited = NO;
		wallNorthHit = NO;
		wallWestHit = NO;
	}
	
    return self;
}

- (void)reset
{
	direction = 0;
	type = [Constants shared].LocationType.DoNothing;
	message = @"";
	teleportId = 0;
	teleportX = 0;
	teleportY = 0;
}

- (void)setWallNorthTextureIdWithNumber: (NSNumber *)textureId
{
	self.WallNorthTextureId = [textureId intValue];
}

- (void)setWallWestTextureIdWithNumber: (NSNumber *)textureId
{
	self.WallWestTextureId = [textureId intValue];
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
    desc = [NSString stringWithFormat: @"%@, x = %d", desc, self.x];
    desc = [NSString stringWithFormat: @"%@, y = %d", desc, self.y];
    desc = [NSString stringWithFormat: @"%@, direction = %d", desc, self.direction];
    desc = [NSString stringWithFormat: @"%@, wallNorth = %d", desc, self.wallNorth];
    desc = [NSString stringWithFormat: @"%@, wallWest = %d", desc, self.wallWest];
    desc = [NSString stringWithFormat: @"%@, type = %d", desc, self.type];
    desc = [NSString stringWithFormat: @"%@, message = %@", desc, self.message];
    desc = [NSString stringWithFormat: @"%@, teleportId = %d", desc, self.teleportId];
    desc = [NSString stringWithFormat: @"%@, teleportX = %d", desc, self.teleportX];
    desc = [NSString stringWithFormat: @"%@, teleportY = %d", desc, self.teleportY];
    desc = [NSString stringWithFormat: @"%@, wallNorthTextureId = %d", desc, self.wallNorthTextureId];
    desc = [NSString stringWithFormat: @"%@, wallWestTextureId = %d", desc, self.wallWestTextureId];
    desc = [NSString stringWithFormat: @"%@, floorTextureId = %d", desc, self.floorTextureId];
    desc = [NSString stringWithFormat: @"%@, ceilingTextureId = %d", desc, self.ceilingTextureId];
    desc = [NSString stringWithFormat: @"%@, visited = %d", desc, self.visited];
    desc = [NSString stringWithFormat: @"%@, wallNorthHit = %d", desc, self.wallNorthHit];
    desc = [NSString stringWithFormat: @"%@, wallWestHit = %d", desc, self.wallWestHit];
    
    return desc;
}

@end
