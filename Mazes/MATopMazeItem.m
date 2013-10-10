//
//  MATopMazeItem.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MATopMazeItem.h"

#import "MAMaze.h"

@implementation MATopMazeItem

- (NSString *)modifiedAtFormatted
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle: NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.modifiedAt];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"maze = %@; ", self.maze];
    desc = [desc stringByAppendingFormat: @"mazeName = %@; ", self.mazeName];
    desc = [desc stringByAppendingFormat: @"averageRating = %f; ", self.averageRating];
    desc = [desc stringByAppendingFormat: @"ratingCount = %d; ", self.ratingCount];
    desc = [desc stringByAppendingFormat: @"userStarted = %d; ", self.userStarted];
    desc = [desc stringByAppendingFormat: @"userRating = %f; ", self.userRating];
    desc = [desc stringByAppendingFormat: @"modifiedAt = %@>", self.modifiedAt];
    
    return desc;
}

@end
