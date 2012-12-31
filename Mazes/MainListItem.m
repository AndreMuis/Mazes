//
//  MainListItem.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MainListItem.h"

@implementation MainListItem

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _mazeId = 0;
        _mazeName = nil;
        _averageRating = 0.0;
        _ratingsCount = 0;
        _userStarted = NO;
        _userRating = 0.0;
        _lastModified = nil;
	}
	
    return self;
}

- (NSString *)lastModifiedFormatted
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle: NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.lastModified];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"mazeId = %d", self.mazeId];
    desc = [NSString stringWithFormat: @"%@, mazeName = %@", desc, self.mazeName];
    desc = [NSString stringWithFormat: @"%@, averageRating = %f", desc, self.averageRating];
    desc = [NSString stringWithFormat: @"%@, ratingsCount = %d", desc, self.ratingsCount];
    desc = [NSString stringWithFormat: @"%@, userStarted = %d", desc, self.userStarted];
    desc = [NSString stringWithFormat: @"%@, userRating = %f", desc, self.userRating];
    desc = [NSString stringWithFormat: @"%@, lastModified = %@", desc, self.lastModified];
    
    return desc;
}

@end
