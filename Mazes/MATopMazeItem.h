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

@property (assign, nonatomic) MAMaze *maze;
@property (strong, nonatomic) NSString *mazeName;
@property (assign, nonatomic) float averageRating;
@property (assign, nonatomic) int ratingCount;
@property (assign, nonatomic) BOOL userStarted;
@property (assign, nonatomic) float userRating;

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSString *updatedAtFormatted;

- (id)initWithDictionary: (NSDictionary *)dictionary;

@end
