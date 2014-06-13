//
//  MAMapSegment.h
//  Mazes
//
//  Created by Andre Muis on 6/12/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMapSegment : NSObject

@property (readonly, assign, nonatomic) CGRect frame;
@property (readwrite, strong, nonatomic) UIColor *color;

- (id)initWithFrame: (CGRect)frame color: (UIColor *)color;

@end
