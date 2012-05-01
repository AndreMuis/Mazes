//
//  Texture.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Texture.h"

@implementation Texture

@synthesize textureId; 
@synthesize name;
@synthesize width; 
@synthesize height; 
@synthesize repeats; 
@synthesize type;
@synthesize order; 
@synthesize imageViewFrame;

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"textureId = %d", self.textureId];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, width = %d", desc, self.width];
    desc = [NSString stringWithFormat: @"%@, height = %d", desc, self.height];
    desc = [NSString stringWithFormat: @"%@, repeats = %d", desc, self.repeats];
    desc = [NSString stringWithFormat: @"%@, type = %d", desc, self.type];
    desc = [NSString stringWithFormat: @"%@, order = %d", desc, self.order];
    
    return desc;
}

@end
