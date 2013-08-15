//
//  MATest.h
//  Mazes
//
//  Created by Andre Muis on 8/4/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface MATest : PFObject <PFSubclassing>

@property NSNumber *aa;

+ (NSString *)parseClassName;

@end
