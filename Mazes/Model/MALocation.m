//
//  MALocation.m
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MALocation.h"

#import "MAMaze.h"
#import "MATextureManager.h"
#import "MATexture.h"

@implementation MALocation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _locationId = nil;
        _coordinate = nil;
        _direction = 0;
        _action = MALocationActionUnknown;
        _message = nil;
        _teleportId = 0;
        _teleportX = 0;
        _teleportY = 0;
        _floorTextureId = nil;
        _ceilingTextureId = nil;
        
        _visited = NO;

        _mapRect = CGRectZero;
        _mapColor = nil;
        
        _mapCornerRect = CGRectZero;
        _mapCornerColor = nil;
    }
    
    return self;
}

- (id)initWithCoder: (NSCoder *)coder
{
    self = [super init];
    
    if (self)
    {
        _locationId = [coder decodeObjectForKey: @"locationId"];
        _coordinate = [coder decodeObjectForKey: @"coordinate"];
        _direction = [coder decodeIntegerForKey: @"direction"];
        _action = [coder decodeIntegerForKey: @"action"];
        _message = [coder decodeObjectForKey: @"message"];
        _teleportId = [coder decodeIntegerForKey: @"teleportId"];
        _teleportX = [coder decodeIntegerForKey: @"teleportX"];
        _teleportY = [coder decodeIntegerForKey: @"teleportY"];
        _floorTextureId = [coder decodeObjectForKey: @"floorTextureId"];
        _ceilingTextureId = [coder decodeObjectForKey: @"ceilingTextureId"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: self.locationId forKey: @"locationId"];
    [coder encodeObject: self.coordinate forKey: @"coordinate"];
    [coder encodeInteger: self.direction forKey: @"direction"];
    [coder encodeInteger: self.action forKey: @"action"];
    [coder encodeObject: self.message forKey: @"message"];
    [coder encodeInteger: self.teleportId forKey: @"teleportId"];
    [coder encodeInteger: self.teleportX forKey: @"teleportX"];
    [coder encodeInteger: self.teleportY forKey: @"teleportY"];
    [coder encodeObject: self.floorTextureId forKey: @"floorTextureId"];
    [coder encodeObject: self.ceilingTextureId forKey: @"ceilingTextureId"];
}

- (NSUInteger)row
{
    return self.coordinate.row;
}

- (NSUInteger)column
{
    return self.coordinate.column;
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

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"locationId = %@; ", self.locationId];
    desc = [desc stringByAppendingFormat: @"row = %d; ", self.row];
    desc = [desc stringByAppendingFormat: @"column = %d; ", self.column];
    desc = [desc stringByAppendingFormat: @"direction = %d; ", self.direction];
    desc = [desc stringByAppendingFormat: @"action = %d; ", self.action];
    desc = [desc stringByAppendingFormat: @"message = %@; ", self.message];
    desc = [desc stringByAppendingFormat: @"teleportX = %d; ", self.teleportX];
    desc = [desc stringByAppendingFormat: @"teleportY = %d; ", self.teleportY];
    desc = [desc stringByAppendingFormat: @"floorTextureId = %@; ", self.floorTextureId];
    desc = [desc stringByAppendingFormat: @"ceilingTextureId = %@; ", self.ceilingTextureId];
    
    return desc;
}

@end
















