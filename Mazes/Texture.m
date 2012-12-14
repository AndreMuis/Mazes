//
//  Texture.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Texture.h"

@implementation Texture

@dynamic id; 
@dynamic name;
@dynamic width; 
@dynamic height; 
@dynamic repeats; 
@dynamic kind;
@dynamic order; 
@dynamic imageViewFrame;

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, width = %d", desc, self.width];
    desc = [NSString stringWithFormat: @"%@, height = %d", desc, self.height];
    desc = [NSString stringWithFormat: @"%@, repeats = %d", desc, self.repeats];
    desc = [NSString stringWithFormat: @"%@, kind = %d", desc, self.kind];
    desc = [NSString stringWithFormat: @"%@, order = %d", desc, self.order];
    
    return desc;
}

@end
