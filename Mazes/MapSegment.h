//
//  MapSegment.h
//  Mazes
//
//  Created by Andre Muis on 8/6/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapSegment : NSObject 

@property (assign, nonatomic) CGRect rect;
@property (strong, nonatomic) UIColor *color;

@end
