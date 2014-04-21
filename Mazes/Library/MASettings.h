//
//  MASettings.h
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MASettings : NSObject

@property (assign, nonatomic) BOOL useTutorial;

@property (assign, nonatomic) BOOL hasSelectedWall;
@property (assign, nonatomic) BOOL hasSelectedLocation;

+ (MASettings *)settings;

@end
