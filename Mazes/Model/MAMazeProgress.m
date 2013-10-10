//
//  MAMazeProgress.m
//  Mazes
//
//  Created by Andre Muis on 9/23/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMazeProgress.h"

#import "MAMaze.h"

@implementation MAMazeProgress

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _mazeProgressId = nil;
        _user = nil;
        _maze = nil;
        _started = NO;
        _foundExit = NO;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"mazeProgressId = %@; ", self.mazeProgressId];
    desc = [desc stringByAppendingFormat: @"maze = %@; ", self.maze];
    desc = [desc stringByAppendingFormat: @"user = %@; ", self.user];
    desc = [desc stringByAppendingFormat: @"started = %d; ", self.started];
    desc = [desc stringByAppendingFormat: @"foundExit = %d>", self.foundExit];
    
    return desc;
}

@end
