//
//  User.m
//  Mazes
//
//  Created by Andre Muis on 12/15/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "User.h"

@implementation User

- (id)init
{
    self = [super init];
	
    if (self)
	{
        _id = 0;
        _udid = nil;
        _createdDate = nil;
        _updatedDate = nil;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, udid = %@", desc, self.udid];
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];
    
    return desc;
}


@end

