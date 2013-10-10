//
//  MAWall.m
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAWall.h"

#import "MACoordinate.h"
#import "MATexture.h"

@implementation MAWall

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _coordinate = nil;
        _direction = MADirectionUnknown;
        _type = MAWallUnknown;
        _textureId = nil;
        
        _mapRect = CGRectZero;
        _mapColor = nil;
        _hit = NO;
	}
	
    return self;
}

- (id)initWithCoder: (NSCoder *)coder
{
    self = [super init];
    
    if (self)
    {
        _coordinate = [coder decodeObjectForKey: @"coordinate"];
        _direction = [coder decodeIntegerForKey: @"direction"];
        _type = [coder decodeIntegerForKey: @"type"];
        _textureId = [coder decodeObjectForKey: @"textureId"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: self.coordinate forKey: @"coordinate"];
    [coder encodeInteger: self.direction forKey: @"direction"];
    [coder encodeInteger: self.type forKey: @"type"];
    [coder encodeObject: self.textureId forKey: @"textureId"];
}

- (NSUInteger)row
{
    return self.coordinate.row;
}

- (NSUInteger)column
{
    return self.coordinate.column;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"row = %d; ", self.row];
    desc = [desc stringByAppendingFormat: @"column = %d; ", self.column];
    desc = [desc stringByAppendingFormat: @"direction = %d; ", self.direction];
    desc = [desc stringByAppendingFormat: @"type = %d; ", self.type];
    desc = [desc stringByAppendingFormat: @"textureId = %@; ", self.textureId];
    
    return desc;
}

@end
