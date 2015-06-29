//
//  MASceneView.h
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

@class MAWorld;

@protocol MASceneViewDelegate;

@interface MASceneView : SCNView

- (void)drawAxes;

- (void)setupWithDelegate: (id<MASceneViewDelegate>)delegate;

- (void)refreshWithWorld: (MAWorld *)world;

@end
