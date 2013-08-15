//
//  MALocation.m
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MALocation.h"
#import "MAMaze.h"
#import "MATexture.h"

@implementation MALocation

@dynamic maze;
@dynamic xx;
@dynamic yy;
@dynamic direction;
@dynamic wallNorth;
@dynamic wallWest;
@dynamic action;
@dynamic message;
@dynamic teleportId;
@dynamic teleportX;
@dynamic teleportY;
@dynamic wallNorthTexture;
@dynamic wallWestTexture;
@dynamic floorTexture;
@dynamic ceilingTexture;
@dynamic visited;
@dynamic wallNorthHit;
@dynamic wallWestHit;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (void)encodeWithCoder: (NSCoder *)encoder
{
    [encoder encodeObject: self.maze.objectId forKey: @"mazeObjectId "];
    [encoder encodeObject: self.author forKey:@"author"];
    [encoder encodeInteger: self.pageCount forKey:@"pageCount"];
    [encoder encodeObject: self.categories forKey:@"categories"];
    [encoder encodeBool: [self isAvailable] forKey:@"available"];
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
	self.wallNorthTexture = nil;
}

- (void)setWallWestTextureIdWithNumber: (NSNumber *)textureId
{
	self.wallWestTexture = nil;
}

- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId
{
	self.floorTexture = nil;
}

- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId
{
	self.ceilingTexture = nil;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"maze.objectId = %@", self.maze.objectId];
    desc = [NSString stringWithFormat: @"%@, xx = %d", desc, self.xx];
    desc = [NSString stringWithFormat: @"%@, yy = %d", desc, self.yy];
    desc = [NSString stringWithFormat: @"%@, direction = %d", desc, self.direction];
    desc = [NSString stringWithFormat: @"%@, wallNorth = %d", desc, self.wallNorth];
    desc = [NSString stringWithFormat: @"%@, wallWest = %d", desc, self.wallWest];
    desc = [NSString stringWithFormat: @"%@, action = %d", desc, self.action];
    desc = [NSString stringWithFormat: @"%@, message = %@", desc, self.message];
    desc = [NSString stringWithFormat: @"%@, teleportId = %d", desc, self.teleportId];
    desc = [NSString stringWithFormat: @"%@, teleportX = %d", desc, self.teleportX];
    desc = [NSString stringWithFormat: @"%@, teleportY = %d", desc, self.teleportY];
    desc = [NSString stringWithFormat: @"%@, wallNorthTexture.objectId = %@", desc, self.wallNorthTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, wallWestTexture.objectId = %@", desc, self.wallWestTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, floorTexture.objectId = %@", desc, self.floorTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, ceilingTexture.objectId = %@", desc, self.ceilingTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, visited = %d", desc, self.visited];
    desc = [NSString stringWithFormat: @"%@, wallNorthHit = %d", desc, self.wallNorthHit];
    desc = [NSString stringWithFormat: @"%@, wallWestHit = %d", desc, self.wallWestHit];
    
    return desc;
}

@end
