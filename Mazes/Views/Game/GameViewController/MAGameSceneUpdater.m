//
//  MAGameSceneUpdater.m
//  Mazes
//
//  Created by Andre Muis on 7/11/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAGameSceneUpdater.h"

@interface MAGameSceneUpdater ()

@property (readonly, strong, nonatomic) SCNPhysicsBody *cameraPhysicsBody;

@end

@implementation MAGameSceneUpdater

+ (instancetype)gameSceneUpdaterWithCameraPhysicsBody: (SCNPhysicsBody *)cameraPhysicsBody
{
    MAGameSceneUpdater *gameSceneUpdater = [[self alloc] initWithCameraPhysicsBody: cameraPhysicsBody];
    
    return gameSceneUpdater;
}

- (instancetype)initWithCameraPhysicsBody: (SCNPhysicsBody *)cameraPhysicsBody
{
    self = [super init];
    
    if (self)
    {
        _cameraPhysicsBody = cameraPhysicsBody;
    }
    
    return self;
}

- (void)renderer: (id<SCNSceneRenderer>)renderer updateAtTime: (NSTimeInterval)time
{
    self.cameraPhysicsBody.velocity = self.cameraVelocity;
    self.cameraPhysicsBody.angularVelocity = self.cameraAngularVelocity;
}

@end
