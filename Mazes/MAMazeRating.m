//
//  MAMazeRating.m
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MAMazeRating.h"

#import "MAMaze.h"
#import "MAUser.h"

@implementation MAMazeRating

@dynamic user;
@dynamic maze;
@dynamic value;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

@end




