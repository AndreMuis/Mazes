//
//  MASound.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MASound : NSObject

@property (readwrite, strong, nonatomic) NSString *soundId;
@property (readwrite, strong, nonatomic) NSString *name;

- (void)setup;

- (void)playWithNumberOfLoops: (int)numberOfLoops;

- (void)stop;

@end
