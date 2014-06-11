//
//  MALatestVersion.m
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MALatestVersion.h"

@implementation MALatestVersion

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _latestVersionId = nil;
        _latestVersion = 0.0;
    }
    
    return self;
}

- (BOOL)isEqual: (id)object
{
    if ([object isKindOfClass: [MALatestVersion class]])
    {
        MALatestVersion *latestVersion = object;
        
        return [self.latestVersionId isEqualToString: latestVersion.latestVersionId];
    }
    
    return NO;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"latestVersionId = %@; ", self.latestVersionId];
    desc = [desc stringByAppendingFormat: @"latestVersion = %f>", self.latestVersion];

    return desc;
}

@end
