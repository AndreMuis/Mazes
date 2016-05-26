//
//  MAGameView.m
//  Mazes
//
//  Created by Andre Muis on 7/5/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAGameView.h"

#import "MAGameSceneUpdater.h"
#import "MAWall.h"
#import "MAWallNode.h"
#import "MAWorld.h"


#import "MABoxNode.h"



@interface MAGameView ()

@property (readonly, strong, nonatomic) SCNNode *worldNode;

@property (readonly, strong, nonatomic) SCNNode *cameraNode;
@property (readonly, strong, nonatomic) SCNPhysicsBody *cameraPhysicsBody;

@property (readonly, strong, nonatomic) MAGameSceneUpdater *gameSceneUpdater;

@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MAGameView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        _gameSceneUpdater = nil;
        
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
    
    SCNBox *box = [SCNBox boxWithWidth: 0.3
                                height: 1.0
                                length: 0.3
                         chamferRadius: 0.0];
    
    SCNPhysicsShape *physicsShape = [SCNPhysicsShape shapeWithGeometry: box
                                                               options: nil];
    
    _cameraPhysicsBody = [SCNPhysicsBody bodyWithType: SCNPhysicsBodyTypeDynamic
                                                shape: physicsShape];
    

    _cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.zNear = 0.01;
    self.cameraNode.physicsBody = self.cameraPhysicsBody;
    
    self.cameraNode.physicsBody.mass = 10.0;
    //self.cameraNode.physicsBody.friction = 0.0;
    self.cameraNode.physicsBody.restitution = 0.0;
    //self.cameraNode.physicsBody.angularDamping = 0.0;

    [self.scene.rootNode addChildNode: self.cameraNode];
    
    self.cameraNode.position = SCNVector3Make(1.5, 0.55, 2.0);
    
    _gameSceneUpdater = [MAGameSceneUpdater gameSceneUpdaterWithCameraPhysicsBody: self.cameraPhysicsBody];
    
    self.delegate = self.gameSceneUpdater;
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor redColor];
    [self.scene.rootNode addChildNode: ambientLightNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.light.color = [UIColor whiteColor];
    lightNode.position = SCNVector3Make(1, 3, 1);
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
    
    
    
    MABoxNode *floorNode = [[MABoxNode alloc] initWithX: 0.0
                                                      y: -wallWidth / 2.0
                                                      z: 0.0
                                                  width: self.world.rows
                                                 height: wallWidth
                                                 length: self.world.columns
                                                  color: [UIColor grayColor]
                                                opacity: 1.0];
    
    [self.worldNode addChildNode: floorNode];
    
    
    
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

- (void)startMovingForward
{
    float xComponent = self.cameraNode.presentationNode.transform.m13 * 2.0;
    float zComponent = -self.cameraNode.presentationNode.transform.m11 * 2.0;
    
    SCNVector3 cameraVelocity = SCNVector3Make(xComponent, 0.0, zComponent);
    
    self.gameSceneUpdater.cameraVelocity = cameraVelocity;
}

- (void)stopMovingForward
{
    SCNVector3 cameraVelocity = SCNVector3Make(0.0, 0.0, 0.0);
    
    self.gameSceneUpdater.cameraVelocity = cameraVelocity;
}

- (void)startRotatingCounterClockwise
{
    self.gameSceneUpdater.cameraAngularVelocity = SCNVector4Make(0.0, 1.0, 0.0, 2.0);
}

- (void)startRotatingClockwise
{
    self.gameSceneUpdater.cameraAngularVelocity = SCNVector4Make(0.0, 1.0, 0.0, -2.0);
}

- (void)stopRotating
{
    self.gameSceneUpdater.cameraAngularVelocity = SCNVector4Make(0.0, 1.0, 0.0, 0.0);
}

- (NSString *)stringWithSCNMatrix4: (SCNMatrix4)martrix
{
    NSString *string = [NSString stringWithFormat: @"%f %f %f %f\n", martrix.m11, martrix.m12, martrix.m13, martrix.m14];
    string = [string stringByAppendingFormat: @"%f %f %f %f\n", martrix.m21, martrix.m22, martrix.m23, martrix.m24];
    string = [string stringByAppendingFormat: @"%f %f %f %f\n", martrix.m31, martrix.m32, martrix.m33, martrix.m34];
    string = [string stringByAppendingFormat: @"%f %f %f %f", martrix.m41, martrix.m42, martrix.m43, martrix.m44];
    
    return string;
}

@end



















