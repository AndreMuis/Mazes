//
//  MAMazeSummary.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAMaze;

@interface MAMazeSummary : NSObject

@property (readwrite, strong, nonatomic) NSString *mazeSummaryId;

@property (readwrite, strong, nonatomic) NSString *mazeId;

@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, assign, nonatomic) float averageRating;
@property (readwrite, assign, nonatomic) int ratingCount;

@property (readwrite, strong, nonatomic) NSDate *modifiedAt;
@property (readonly, strong, nonatomic) NSString *modifiedAtFormatted;

@property (readwrite, assign, nonatomic) BOOL userStarted;
@property (readwrite, assign, nonatomic) BOOL userFoundExit;
@property (readwrite, assign, nonatomic) float rating;

@end


