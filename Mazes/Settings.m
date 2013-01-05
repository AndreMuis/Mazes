//
//  Settings.m
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (Settings *)shared
{
	static Settings *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Settings alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], @"useTutorial", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
        
        self->userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (BOOL)useTutorial
{
    return [userDefaults boolForKey: @"useTutorial"];
}

- (void)setUseTutorial: (BOOL)anUseTutorial
{
    [userDefaults setBool: anUseTutorial forKey: @"useTutorial"];
}

@end