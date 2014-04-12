//
//  MASoundManager.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASound;

@interface MASoundManager : NSObject

@property (assign, nonatomic, readonly) int count;

- (id)initWithSounds: (NSArray *)sounds;

- (NSArray *)sortedByName;

@end
