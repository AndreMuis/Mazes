//
//  MAVersion.m
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MAVersion.h"

@implementation MAVersion

@dynamic number;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"number = %f", self.number];
    
    return desc;
}

@end
