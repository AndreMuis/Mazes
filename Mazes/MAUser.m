//
//  MAUser.m
//  Mazes
//
//  Created by Andre Muis on 12/15/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MAUser.h"

@implementation MAUser

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"objectId = %@", self.objectId];
    
    return desc;
}

@end

