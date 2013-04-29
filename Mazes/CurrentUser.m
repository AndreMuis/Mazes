//
//  CurrentUser.m
//  Mazes
//
//  Created by Andre Muis on 1/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "CurrentUser.h"

@interface CurrentUser ()

@property (strong, nonatomic) NSString *userIdKey;

@end

@implementation CurrentUser

+ (CurrentUser *)shared
{
	static CurrentUser *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[CurrentUser alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _userIdKey = @"UserIdKey";
        
        if ([[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].count == 0)
        {
            [self setId: 0];
        }
    }
    
    return self;
}

- (int)id
{
    return [[NSUbiquitousKeyValueStore defaultStore] longLongForKey: self.userIdKey];
}

- (void)setId: (int)anId
{
    [[NSUbiquitousKeyValueStore defaultStore] setLongLong: anId forKey: self.userIdKey];
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

@end

