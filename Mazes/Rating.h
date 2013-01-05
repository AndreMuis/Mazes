//
//  Rating.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rating : NSObject

@property (assign, nonatomic) int mazeId;
@property (assign, nonatomic) int userId;
@property (assign, nonatomic) float value;

@end
