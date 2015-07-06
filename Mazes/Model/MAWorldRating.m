//
//  MAWorldRating.m
//  Mazes
//
//  Created by Andre Muis on 7/3/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAWorldRating.h"

@implementation MAWorldRating

+ (instancetype)worldRatingWithUserRecodName: (NSString *)userRecordName
                                       value: (float)value
{
    MAWorldRating *worldRating = [[self alloc] initWithUserRecordName: userRecordName
                                                                value: value];

    return worldRating;
}

- (instancetype)initWithUserRecordName: (NSString *)userRecordName
                                 value: (float)value
{
    self = [super init];
    
    if (self)
    {
        _userRecordName = userRecordName;
        _value = value;
    }
    
    return self;
}

- (id)initWithCoder: (NSCoder *)coder
{
    self = [super init];
    
    if (self)
    {
        _userRecordName = [coder decodeObjectForKey: @"userRecordName"];
        _value = [coder decodeFloatForKey: @"value"];
    }
    
    return self;
}

- (void)updateWithValue: (float)value
{
    _value = value;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: self.userRecordName forKey: @"userRecordName"];
    [coder encodeFloat: self.value forKey: @"value"];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"userRecordName = %@; ", self.userRecordName];
    desc = [desc stringByAppendingFormat: @"value = %d>", (int)self.value];
    
    return desc;
}

@end
















