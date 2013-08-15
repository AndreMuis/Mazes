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

- (id)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
	
	if (self)
	{
        _maze = [dictionary valueForKey: @"maze"];
        _mazeName = [dictionary valueForKey: @"mazeName"];
        _averageRating = [[dictionary valueForKey: @"averageRating"] floatValue];
        _ratingCount = [[dictionary valueForKey: @"ratingCount"] intValue];
        _userStarted = [[dictionary valueForKey: @"userStarted"] boolValue];
        _userRating = [[dictionary valueForKey: @"userRating"] floatValue];
        _updatedAt = [dictionary valueForKey: @"updatedAt"];
	}
	
    return self;
}

- (NSString *)lastModifiedFormatted
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle: NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.updatedAt];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"maze = %@", self.maze];
    desc = [NSString stringWithFormat: @"%@, mazeName = %@", desc, self.mazeName];
    desc = [NSString stringWithFormat: @"%@, averageRating = %f", desc, self.averageRating];
    desc = [NSString stringWithFormat: @"%@, ratingCount = %d", desc, self.ratingCount];
    desc = [NSString stringWithFormat: @"%@, userStarted = %d", desc, self.userStarted];
    desc = [NSString stringWithFormat: @"%@, userRating = %f", desc, self.userRating];
    desc = [NSString stringWithFormat: @"%@, updatedAt = %@", desc, self.updatedAt];
    
    return desc;
}

@end
