//
//  MAMazeRating.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMFatFractal/AMFatFractal.h>

@class MAMaze;

@interface MAMazeRating : NSObject

@property (readwrite, strong, nonatomic) NSString *mazeRatingId;
@property (readwrite, strong, nonatomic) MAMaze *maze;
@property (readwrite, strong, nonatomic) FFUser *user;
@property (readwrite, assign, nonatomic) float userRating;

@end






