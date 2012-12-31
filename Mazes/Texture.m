//
//  Texture.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
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
@dynamic createdDate;
@dynamic updatedDate;

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, width = %d", desc, self.width];
    desc = [NSString stringWithFormat: @"%@, height = %d", desc, self.height];
    desc = [NSString stringWithFormat: @"%@, repeats = %d", desc, self.repeats];
    desc = [NSString stringWithFormat: @"%@, kind = %d", desc, self.kind];
    desc = [NSString stringWithFormat: @"%@, order = %d", desc, self.order];
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];

    return desc;
}

@end
