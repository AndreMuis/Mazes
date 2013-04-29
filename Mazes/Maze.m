//
//  Maze.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "Maze.h"
#import "Locations.h"

@implementation Maze

- (id)init
{
	self = [super init];
	
    if (self)
	{
        _id = 0;
        _userId = 0;
        _name = @"";
        _rows = 0;
        _columns = 0;
        _active = NO;
        _public = NO;
        _backgroundSoundId = 0;
        _wallTextureId = 0;
        _floorTextureId = 0;
        _ceilingTextureId = 0;
        _createdDate = nil;
        _updatedDate = nil;
        
		_locations = [[Locations alloc] init];
	}
	
	return self;
}

- (void)setWallTextureIdWithNumber: (NSNumber *)textureId
{
	self.wallTextureId = [textureId intValue];
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
    desc = [NSString stringWithFormat: @"%@, userId = %d", desc, self.userId];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, rows = %d", desc, self.rows];
    desc = [NSString stringWithFormat: @"%@, columns = %d", desc, self.columns];
    desc = [NSString stringWithFormat: @"%@, active = %d", desc, self.active];
    desc = [NSString stringWithFormat: @"%@, public = %d", desc, self.public];
    desc = [NSString stringWithFormat: @"%@, backgroundSoundId = %d", desc, self.backgroundSoundId];
    desc = [NSString stringWithFormat: @"%@, wallTextureId = %d", desc, self.wallTextureId];
    desc = [NSString stringWithFormat: @"%@, floorTextureId = %d", desc, self.floorTextureId];
    desc = [NSString stringWithFormat: @"%@, ceilingTextureId = %d", desc, self.ceilingTextureId];
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];
    
    desc = [NSString stringWithFormat: @"%@, locations = %@", desc, self.locations];

    return desc;
}

@end





