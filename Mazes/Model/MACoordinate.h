//
//  MACoordinate.h
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACoordinate : NSObject <NSCoding>

@property (readwrite, assign, nonatomic) NSUInteger row;
@property (readwrite, assign, nonatomic) NSUInteger column;

@end
