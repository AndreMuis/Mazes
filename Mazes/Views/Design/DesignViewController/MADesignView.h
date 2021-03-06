//
//  MADesignView.h
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

@class MAWorld;

@protocol MADesignViewDelegate;

@interface MADesignView : SCNView

- (void)drawAxes;

- (void)setupWithDelegate: (id<MADesignViewDelegate>)delegate;

- (void)refreshWithWorld: (MAWorld *)world;

@end
