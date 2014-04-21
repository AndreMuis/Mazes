//
//  MASettings.m
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MASettings.h"

#import "MAConstants.h"

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
        NSDictionary *defaults = @{MAUseTutorialKey : [NSNumber numberWithBool: YES],
                                   MAHasSelectedLocationKey : [NSNumber numberWithBool: NO],
                                   MAHasSelectedWallKey : [NSNumber numberWithBool: NO]};
                                   
        [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
     
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (BOOL)useTutorial
{
    return [self.userDefaults boolForKey: MAUseTutorialKey];
}

- (void)setUseTutorial: (BOOL)useTutorial
{
    [self.userDefaults setBool: useTutorial forKey: MAUseTutorialKey];
}


- (BOOL)hasSelectedLocation
{
    return [self.userDefaults boolForKey: MAHasSelectedLocationKey];
}

- (void)setHasSelectedLocation: (BOOL)hasSelectedLocation
{
    [self.userDefaults setBool: hasSelectedLocation forKey: MAHasSelectedLocationKey];
}


- (BOOL)hasSelectedWall
{
    return [self.userDefaults boolForKey: MAHasSelectedWallKey];
}

- (void)setHasSelectedWall: (BOOL)hasSelectedWall
{
    [self.userDefaults setBool: hasSelectedWall forKey: MAHasSelectedWallKey];
}

@end






















