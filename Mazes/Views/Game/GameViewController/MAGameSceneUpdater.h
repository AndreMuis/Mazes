//
//  MAGameSceneUpdater.h
//  Mazes
//
//  Created by Andre Muis on 7/11/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface MAGameSceneUpdater : NSObject <SCNSceneRendererDelegate>

@property (readwrite, assign, nonatomic) SCNVector3 cameraVelocity;
@property (readwrite, assign, nonatomic) SCNVector4 cameraAngularVelocity;

+ (instancetype)gameSceneUpdaterWithCameraPhysicsBody: (SCNPhysicsBody *)cameraPhysicsBody;

- (instancetype)initWithCameraPhysicsBody: (SCNPhysicsBody *)cameraPhysicsBody;

@end
