//
//  MATexture.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MATexture.h"

@implementation MATexture

@dynamic name;
@dynamic width; 
@dynamic height; 
@dynamic repeats; 
@dynamic kind;
@dynamic order; 

@synthesize glId;
@synthesize imageViewFrame;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"name = %@", self.name];
    desc = [NSString stringWithFormat: @"%@, width = %d", desc, self.width];
    desc = [NSString stringWithFormat: @"%@, height = %d", desc, self.height];
    desc = [NSString stringWithFormat: @"%@, repeats = %d", desc, self.repeats];
    desc = [NSString stringWithFormat: @"%@, kind = %d", desc, self.kind];
    desc = [NSString stringWithFormat: @"%@, order = %d", desc, self.order];

    return desc;
}

@end
