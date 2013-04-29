//
//  Settings.h
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (assign, nonatomic) BOOL useTutorial;

+ (Settings *)shared;

@end
