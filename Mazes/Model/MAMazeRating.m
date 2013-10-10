//
//  MAMazeRating.m
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMazeRating.h"

#import "MAMaze.h"

@implementation MAMazeRating

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _mazeRatingId = nil;
        _maze = nil;
        _user = nil;
        _userRating = 0.0;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"\tmazeRatingId = %@; ", self.mazeRatingId];
    desc = [desc stringByAppendingFormat: @"\tmaze = %@; ", self.maze];
    desc = [desc stringByAppendingFormat: @"\tuser = %@; ", self.user];
    desc = [desc stringByAppendingFormat: @"\tuserRating = %f>", self.userRating];
    
    return desc;
}

@end




