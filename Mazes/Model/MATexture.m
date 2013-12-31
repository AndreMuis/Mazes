//
//  MATexture.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATexture.h"

@implementation MATexture

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _textureId = nil;
        _name = nil;
        _width = 0;
        _height = 0;
        _repeats = 0;
        _kind = 0;
        _order = 0;
	}
	
    return self;
}

- (BOOL)isEqual: (id)object
{
    if ([object isKindOfClass: [MATexture class]])
    {
        MATexture *texture = object;
        
        return [self.textureId isEqualToString: texture.textureId];
    }
    
    return NO;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"textureId = %@; ", self.textureId];
    desc = [desc stringByAppendingFormat: @"name = %@; ", self.name];
    desc = [desc stringByAppendingFormat: @"width = %d; ", self.width];
    desc = [desc stringByAppendingFormat: @"height = %d; ", self.height];
    desc = [desc stringByAppendingFormat: @"repeats = %d; ", self.repeats];
    desc = [desc stringByAppendingFormat: @"kind = %d; ", self.kind];
    desc = [desc stringByAppendingFormat: @"order = %d>", self.order];
    
    return desc;
}

@end
