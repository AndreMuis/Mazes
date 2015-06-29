//
//  MAMazeSummary.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMazeSummary.h"

#import "MAWorld.h"

@implementation MAMazeSummary

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
    
    desc = [desc stringByAppendingFormat: @"mazeSummaryId = %@; ", self.mazeSummaryId];

    desc = [desc stringByAppendingFormat: @"mazeId = %@; ", self.mazeId];

    desc = [desc stringByAppendingFormat: @"name = %@; ", self.name];
    desc = [desc stringByAppendingFormat: @"averageRating = %f; ", self.averageRating];
    desc = [desc stringByAppendingFormat: @"ratingCount = %d; ", (int)self.ratingCount];

    desc = [desc stringByAppendingFormat: @"modifiedAt = %@; ", self.modifiedAt];
    desc = [desc stringByAppendingFormat: @"modifiedAtFormatted = %@; ", self.modifiedAtFormatted];

    desc = [desc stringByAppendingFormat: @"userStarted = %d; ", self.userStarted];
    desc = [desc stringByAppendingFormat: @"userFoundExit = %d; ", self.userFoundExit];
    desc = [desc stringByAppendingFormat: @"rating = %f>", self.rating];

    return desc;
}

@end
