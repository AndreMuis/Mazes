//
//  Version.m
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "Version.h"

@implementation Version

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"number = %f", self.number];
    
    return desc;
}

@end
