//
//  MazeUser.m
//  Mazes
//
//  Created by Andre Muis on 12/31/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MazeUser.h"

@implementation MazeUser

- (id)init
{
	self = [super init];
	
    if (self)
	{
        _id = 0;
        _mazeId = 0;
        _userId = 0;
        _started = NO;
        _finished = NO;
        _rating = 0.0;
        _createdDate = nil;
        _updatedDate = nil;
	}
	
	return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, mazeId = %d", desc, self.mazeId];
    desc = [NSString stringWithFormat: @"%@, userId = %d", desc, self.userId];
    desc = [NSString stringWithFormat: @"%@, started = %d", desc, self.started];
    desc = [NSString stringWithFormat: @"%@, finished = %d", desc, self.finished];
    desc = [NSString stringWithFormat: @"%@, rating = %f", desc, self.rating];
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];
    
    return desc;
}

@end
