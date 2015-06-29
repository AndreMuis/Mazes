//
//  MASceneViewDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASceneView;
@class MAWallNode;

@protocol MASceneViewDelegate <NSObject>

@required

- (void)sceneView: (MASceneView *)sceneView
   didTapWallNode: (MAWallNode *)wallNode;

@end
