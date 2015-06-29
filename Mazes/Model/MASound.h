//
//  MASound.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@interface MASound : NSObject

@property (readonly, strong, nonatomic) NSString *soundId;
@property (readonly, strong, nonatomic) NSString *name;

- (void)setup;

- (void)playWithNumberOfLoops: (int)numberOfLoops;

- (void)stop;

@end
