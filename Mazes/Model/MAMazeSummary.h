//
//  MAMazeSummary.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAWorld;

@interface MAMazeSummary : NSObject

@property (readonly, strong, nonatomic) NSString *mazeSummaryId;

@property (readonly, strong, nonatomic) NSString *mazeId;

@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, assign, nonatomic) float averageRating;
@property (readonly, assign, nonatomic) NSUInteger ratingCount;

@property (readonly, strong, nonatomic) NSDate *modifiedAt;
@property (readonly, strong, nonatomic) NSString *modifiedAtFormatted;

@property (readonly, assign, nonatomic) BOOL userStarted;
@property (readonly, assign, nonatomic) BOOL userFoundExit;
@property (readonly, assign, nonatomic) float rating;

@end


