//
//  MATexture.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface MATexture : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) int repeats;
@property (assign, nonatomic) int kind;
@property (assign, nonatomic) int order;

@property (assign, nonatomic) int glId;

@property (assign, nonatomic) CGRect imageViewFrame;

+ (NSString *)parseClassName;

@end
