//
//  MAMazeProgress.h
//  Mazes
//
//  Created by Andre Muis on 9/23/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMFatFractal/AMFatFractal.h>

@class MAMaze;

@interface MAMazeProgress : NSObject

@property (readwrite, strong, nonatomic) NSString *mazeProgressId;
@property (readwrite, strong, nonatomic) FFUser *user;
@property (readwrite, strong, nonatomic) MAMaze *maze;
@property (readwrite, assign, nonatomic) BOOL started;
@property (readwrite, assign, nonatomic) BOOL foundExit;

@end
