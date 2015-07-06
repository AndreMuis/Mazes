//
//  MAGameView.m
//  Mazes
//
//  Created by Andre Muis on 7/5/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAGameView.h"

#import "MAWall.h"
#import "MAWallNode.h"
#import "MAWorld.h"

@interface MAGameView ()

@property (readonly, strong, nonatomic) SCNNode *worldNode;

@property (readonly, strong, nonatomic) SCNNode *cameraBaseNode;
@property (readonly, strong, nonatomic) SCNNode *cameraNode;

@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MAGameView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        _world = nil;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite: 0.5 alpha: 1.0];
    
    self.scene = [SCNScene scene];
    
    _worldNode = [SCNNode node];
    [self.scene.rootNode addChildNode: self.worldNode];
    
    _cameraBaseNode = [SCNNode node];
    self.cameraBaseNode.pivot = SCNMatrix4MakeTranslation(0.0, -0.5, -3.0);
    
    [self.scene.rootNode addChildNode: self.cameraBaseNode];
    
    _cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.zNear = 0.01;
    
    [self.cameraBaseNode addChildNode: self.cameraNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    [self.scene.rootNode addChildNode: ambientLightNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(10, 10, 10);
    [self.scene.rootNode addChildNode: lightNode];
}

- (void)setupWithWorld: (MAWorld *)world
{
    _world = world;
}

- (void)drawWorld
{
    CGFloat wallWidth = 0.1;
    
    for (SCNNode *node in self.worldNode.childNodes)
    {
        [node removeFromParentNode];
    }
    
    for (NSUInteger index = 0; index < [self.world wallsCount]; index = index + 1)
    {
        MAWall *wall = [self.world wallAtIndex: index];
        
        MAWallNode *wallNode = [MAWallNode wallWithWall: wall
                                                    row: wall.row
                                                 column: wall.column
                                           wallPosition: wall.position
                                              wallWidth: wallWidth];
        
        [self.worldNode addChildNode: wallNode];
    }
}

@end



















