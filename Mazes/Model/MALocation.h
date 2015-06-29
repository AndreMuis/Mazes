//
//  MALocation.h
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MALocation : NSObject <NSCoding>

@property (readonly, assign, nonatomic) NSUInteger row;
@property (readonly, assign, nonatomic) NSUInteger column;

+ (instancetype)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column;

- (instancetype)initWithRow: (NSUInteger)row
                     column: (NSUInteger)column;

@end
















