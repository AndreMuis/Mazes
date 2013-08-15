//
//  MAVersion.h
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface MAVersion : PFObject <PFSubclassing>

@property (assign, nonatomic) float number;

+ (NSString *)parseClassName;

@end
