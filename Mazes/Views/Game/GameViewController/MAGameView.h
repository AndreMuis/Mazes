//
//  MAGameView.h
//  Mazes
//
//  Created by Andre Muis on 7/5/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@class MAWorld;

@interface MAGameView : SCNView

- (void)setupWithWorld: (MAWorld *)world;

- (void)drawWorld;

@end
