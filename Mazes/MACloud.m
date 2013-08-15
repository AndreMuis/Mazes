//
//  MACloud.m
//  Mazes
//
//  Created by Andre Muis on 1/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MACloud.h"

@interface MACloud ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSString *currentUserObjectIdKey;

@end

@implementation MACloud

+ (MACloud *)shared
{
	static MACloud *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MACloud alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _currentUserObjectIdKey = @"currentUserObjectIdKey";
        
        #if TARGET_IPHONE_SIMULATOR
        
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        #else
        
        _userDefaults = nil;
        
        if ([[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].count == 0)
        {
            [self setCurrentUserObjectId: nil];
        }

        #endif
    }
    
    return self;
}

- (NSString *)currentUserObjectId
{
    #if TARGET_IPHONE_SIMULATOR

    return [self.userDefaults stringForKey: self.currentUserObjectIdKey];

    #else
    
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey: self.currentUserObjectIdKey];
    
    #endif
}

- (void)setCurrentUserObjectId: (NSString *)currentUserObjectId
{
    #if TARGET_IPHONE_SIMULATOR
    
    [self.userDefaults setObject: currentUserObjectId forKey: self.currentUserObjectIdKey];
    [self.userDefaults synchronize];
    
    #else
    
    [[NSUbiquitousKeyValueStore defaultStore]: currentUserObjectId forKey: self.currentUserObjectIdKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    #endif
}

@end




















