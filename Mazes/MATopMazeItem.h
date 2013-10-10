//
//  MATopMazeItem.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAMaze;

@interface MATopMazeItem : NSObject

@property (readwrite, assign, nonatomic) MAMaze *maze;
@property (readwrite, strong, nonatomic) NSString *mazeName;
@property (readwrite, assign, nonatomic) float averageRating;
@property (readwrite, assign, nonatomic) int ratingCount;
@property (readwrite, assign, nonatomic) BOOL userStarted;
@property (readwrite, assign, nonatomic) float userRating;

@property (readwrite, strong, nonatomic) NSDate *modifiedAt;
@property (readonly, strong, nonatomic) NSString *modifiedAtFormatted;

@end
