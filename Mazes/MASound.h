//
//  MASound.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface MASound : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;

+ (NSString *)parseClassName;

- (void)setup;

- (void)playWithNumberOfLoops: (int)numberOfLoops;

- (void)stop;

@end
