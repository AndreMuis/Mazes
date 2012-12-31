//
//  MazeUser.h
//  Mazes
//
//  Created by Andre Muis on 12/31/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MazeUser : NSObject

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int mazeId;
@property (assign, nonatomic) int userId;
@property (assign, nonatomic) BOOL started;
@property (assign, nonatomic) BOOL finished;
@property (assign, nonatomic) float rating;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

@end
