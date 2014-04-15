//
//  MASettings.m
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MASettings.h"

@interface MASettings ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation MASettings

+ (MASettings *)settings
{
    MASettings *settings = [[MASettings alloc] init];
    return settings;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], @"useTutorial", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (BOOL)useTutorial
{
    return [self.userDefaults boolForKey: @"useTutorial"];
}

- (void)setUseTutorial: (BOOL)anUseTutorial
{
    [self.userDefaults setBool: anUseTutorial forKey: @"useTutorial"];
}

@end
