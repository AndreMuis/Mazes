//
//  MAMazeRating.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@class MAMaze;
@class MAUser;

@interface MAMazeRating : PFObject <PFSubclassing>

@property (strong, nonatomic) MAMaze *maze;
@property (strong, nonatomic) MAUser *user;
@property (assign, nonatomic) float value;

+ (NSString *)parseClassName;

@end






