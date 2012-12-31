//
//  Location.m
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)init
{
    self = [super init];
	
    if (self)
	{
        _id = 0;
		_mazeId = 0;
		_x = 0;
		_y = 0;
		_direction = 0;
		_wallNorth = MAWallSolid;
		_wallWest = MAWallSolid;
		_action = MALocationActionDoNothing;
		_message = @"";
		_teleportId = 0;
		_teleportX = 0;
		_teleportY = 0;
		_wallNorthTextureId = 0;
		_wallWestTextureId = 0;
		_floorTextureId = 0;
		_ceilingTextureId = 0;
		_visited = NO;
		_wallNorthHit = NO;
		_wallWestHit = NO;
        _createdDate = nil;
        _updatedDate = nil;
	}
	
    return self;
}

- (void)reset
{
	self.direction = 0;
	self.action = MALocationActionDoNothing;
	self.message = @"";
	self.teleportId = 0;
	self.teleportX = 0;
	self.teleportY = 0;
}

- (void)setWallNorthTextureIdWithNumber: (NSNumber *)textureId
{
	self.wallNorthTextureId = [textureId intValue];
}

- (void)setWallWestTextureIdWithNumber: (NSNumber *)textureId
{
	self.wallWestTextureId = [textureId intValue];
}

- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId
{
	self.floorTextureId = [textureId intValue];
}

- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId
{
	self.ceilingTextureId = [textureId intValue];
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, mazeId = %d", desc, self.mazeId];
    desc = [NSString stringWithFormat: @"%@, x = %d", desc, self.x];
    desc = [NSString stringWithFormat: @"%@, y = %d", desc, self.y];
    desc = [NSString stringWithFormat: @"%@, direction = %d", desc, self.direction];
    desc = [NSString stringWithFormat: @"%@, wallNorth = %d", desc, self.wallNorth];
    desc = [NSString stringWithFormat: @"%@, wallWest = %d", desc, self.wallWest];
    desc = [NSString stringWithFormat: @"%@, action = %d", desc, self.action];
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
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];
    
    return desc;
}

@end
