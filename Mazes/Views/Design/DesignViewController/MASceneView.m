//
//  MASceneView.m
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MASceneView.h"

#import "MAConstants.h"
#import "MASceneViewDelegate.h"
#import "MAWall.h"
#import "MAWallNode.h"
#import "MAWorld.h"

@interface MASceneView ()

@property (readonly, strong, nonatomic) id<MASceneViewDelegate> maSceneViewDelegate;

@property (readonly, strong, nonatomic) MAWorld *world;

@property (readonly, strong, nonatomic) SCNNode *worldNode;

@property (readonly, strong, nonatomic) SCNNode *lookAtNode;
@property (readonly, strong, nonatomic) SCNNode *cameraBaseNode;
@property (readonly, strong, nonatomic) SCNNode *cameraNode;

@property (readwrite, assign, nonatomic) SCNVector3 lookAtPositionSaved;

@property (readwrite, assign, nonatomic) CGFloat cameraXAngleSaved;

@property (readwrite, assign, nonatomic) SCNMatrix4 cameraBaseNodePivotSaved;

@property (readwrite, assign, nonatomic) CGFloat cameraYAngleSaved;

@end

@implementation MASceneView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if (self)
    {
        _maSceneViewDelegate = nil;
        
        _world = nil;
        
        _worldNode = nil;
        
        _lookAtNode = nil;
        _cameraBaseNode = nil;
        _cameraNode = nil;
        
        _lookAtPositionSaved = SCNVector3Zero;
        
        _cameraXAngleSaved = 0.0;
        
        _cameraBaseNodePivotSaved = SCNMatrix4Identity;
        
        _cameraYAngleSaved = 0.0;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite: 0.5 alpha: 1.0];
    
    SCNScene *scene = [SCNScene scene];
 
    _worldNode = [SCNNode node];
    [scene.rootNode addChildNode: self.worldNode];
    
    _lookAtNode = [SCNNode node];
    self.lookAtNode.position = SCNVector3Make(0.0,
                                              0.0,
                                              0.0);
    
    [scene.rootNode addChildNode: self.lookAtNode];
    
    _cameraBaseNode = [SCNNode node];
    self.cameraBaseNode.pivot = SCNMatrix4MakeTranslation(0.0, -6.0, -6.0);
    
    [self.lookAtNode addChildNode: self.cameraBaseNode];
    
    _cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.zNear = 0.01;
    
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget: self.lookAtNode];
    constraint.gimbalLockEnabled = YES;
    self.cameraNode.constraints = @[constraint];
    
    [self.cameraBaseNode addChildNode: self.cameraNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode: ambientLightNode];

    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(10, 10, 10);
    [scene.rootNode addChildNode: lightNode];
    
    self.scene = scene;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(viewTapped:)];
    
    [self addGestureRecognizer: tapGestureRecognizer];
    
    
    UIPanGestureRecognizer *oneTouchPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                                                   action: @selector(viewOneTouchPanned:)];
    
    oneTouchPanGestureRecognizer.minimumNumberOfTouches = 1;
    oneTouchPanGestureRecognizer.maximumNumberOfTouches = 1;
    
    [self addGestureRecognizer: oneTouchPanGestureRecognizer];
    
    
    UIPanGestureRecognizer *twoTouchPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                                                   action: @selector(viewTwoTouchPanned:)];
    
    twoTouchPanGestureRecognizer.minimumNumberOfTouches = 2;
    twoTouchPanGestureRecognizer.maximumNumberOfTouches = 2;
    
    [self addGestureRecognizer: twoTouchPanGestureRecognizer];
    
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget: self
                                                                                                 action: @selector(viewPinched:)];
    
    [self addGestureRecognizer: pinchGestureRecognizer];
    
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget: self
                                                                                                          action: @selector(viewRotated:)];
    
    [self addGestureRecognizer: rotationGestureRecognizer];

    self.showsStatistics = YES;
    [self drawAxes];
}

- (void)setupWithDelegate: (id<MASceneViewDelegate>)delegate
{
    _maSceneViewDelegate = delegate;
}

- (void)refreshWithWorld: (MAWorld *)world
{
    _world = world;

    [self drawWorld];

    CGFloat lookAtX = self.world.columns / 2.0;
    CGFloat lookAtZ = self.world.rows / 2.0;

    self.lookAtNode.position = SCNVector3Make(lookAtX,
                                              0.0,
                                              lookAtZ);
}

- (void)drawWorld
{
    CGFloat wallWidth = 0.1;

    for (SCNNode *node in self.worldNode.childNodes)
    {
        [node removeFromParentNode];
    }
    
    for (NSUInteger column = 0; column < self.world.columns; column = column + 1)
    {
        for (NSUInteger row = 0; row < self.world.rows; row = row + 1)
        {
            MAWall *topWall = [self.world wallWithRow: row
                                               column: column
                                             position: MAWallPositionTop];

            MAWallNode *topWallNode = [MAWallNode wallWithWall: topWall
                                                           row: row
                                                        column: column
                                                  wallPosition: MAWallPositionTop
                                                     wallWidth: wallWidth];
            
            [self.worldNode addChildNode: topWallNode];

            if (row == self.world.rows - 1)
            {
                MAWall *bottomWall = [self.world wallWithRow: row + 1
                                                      column: column
                                                    position: MAWallPositionTop];

                MAWallNode *bottomWallNode = [MAWallNode wallWithWall: bottomWall
                                                                  row: row + 1
                                                               column: column
                                                         wallPosition: MAWallPositionTop
                                                            wallWidth: wallWidth];
                
                [self.worldNode addChildNode: bottomWallNode];
            }
            
            MAWall *leftWall = [self.world wallWithRow: row
                                                column: column
                                              position: MAWallPositionLeft];
            
            MAWallNode *leftWallNode = [MAWallNode wallWithWall: leftWall
                                                            row: row
                                                         column: column
                                                   wallPosition: MAWallPositionLeft
                                                      wallWidth: wallWidth];
            
            [self.worldNode addChildNode: leftWallNode];
            
            if (column == self.world.columns - 1)
            {
                MAWall *rightWall = [self.world wallWithRow: row
                                                     column: column + 1
                                                   position: MAWallPositionLeft];
                
                MAWallNode *rightWallNode = [MAWallNode wallWithWall: rightWall
                                                                 row: row
                                                              column: column + 1
                                                        wallPosition: MAWallPositionLeft
                                                           wallWidth: wallWidth];
                
                [self.worldNode addChildNode: rightWallNode];
            }
        }
    }
}

- (void)viewTapped: (UITapGestureRecognizer *)recognizer
{
    SCNView *sceneView = (SCNView *)self;
    
    CGPoint touchPoint = [recognizer locationInView: sceneView];
    
    NSArray *hitTestResults = [sceneView hitTest: touchPoint
                                         options: nil];
    
    if (hitTestResults.count >= 1)
    {
        SCNHitTestResult *firstResult = hitTestResults[0];
        
        if ([firstResult.node isMemberOfClass: [MAWallNode class]] == YES)
        {
            MAWallNode *wallNode = (MAWallNode *)firstResult.node;
         
            switch (wallNode.wallPosition)
            {
                case MAWallPositionTop:
                    
                    break;

                default:
                    break;
            }
            
            [self.maSceneViewDelegate sceneView: self
                                 didTapWallNode: wallNode];
        }
    }
}

- (void)viewOneTouchPanned: (UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.lookAtPositionSaved = self.lookAtNode.position;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint panTranslation = [recognizer translationInView: self];
        
        CGFloat panAngle = -self.cameraBaseNode.eulerAngles.y;
        
        CGFloat translationX = panTranslation.x * cos(panAngle) - panTranslation.y * sin(panAngle);
        CGFloat translationZ = panTranslation.x * sin(panAngle) + panTranslation.y * cos(panAngle);
        
        CGFloat cameraBaseNodeScale = self.cameraBaseNode.pivot.m11;
        
        CGFloat lookAtX = self.lookAtPositionSaved.x - translationX / (cameraBaseNodeScale * 200.0);
        CGFloat lookAtZ = self.lookAtPositionSaved.z - translationZ / (cameraBaseNodeScale * 200.0);
        
        if (lookAtX < 0.0)
        {
            lookAtX = 0.0;
        }
        else if (lookAtX > self.world.columns)
        {
            lookAtX = self.world.columns;
        }
        
        if (lookAtZ < 0.0)
        {
            lookAtZ = 0.0;
        }
        else if (lookAtZ > self.world.rows)
        {
            lookAtZ = self.world.rows;
        }
        
        self.lookAtNode.position = SCNVector3Make(lookAtX,
                                                  self.lookAtNode.position.y,
                                                  lookAtZ);
    }
}

- (void)viewTwoTouchPanned: (UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.cameraXAngleSaved = self.cameraBaseNode.eulerAngles.x;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint panTranslation = [recognizer translationInView: self];
        
        CGFloat cameraXAngle = self.cameraXAngleSaved - panTranslation.y / 200.0;
        
        if (cameraXAngle < -M_PI / 4.0)
        {
            cameraXAngle = -M_PI / 4.0;
        }
        else if (cameraXAngle > M_PI / 8.0)
        {
            cameraXAngle = M_PI / 8.0;
        }
        
        self.cameraBaseNode.eulerAngles = SCNVector3Make(cameraXAngle,
                                                         self.cameraBaseNode.eulerAngles.y,
                                                         self.cameraBaseNode.eulerAngles.z);
    }
}

- (void)viewPinched: (UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.cameraBaseNodePivotSaved = self.cameraBaseNode.pivot;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat cameraBaseY = -self.cameraBaseNodePivotSaved.m42;
        CGFloat cameraBaseYScale = self.cameraBaseNodePivotSaved.m22;
        
        CGFloat cameraBaseYScaled = cameraBaseY * (1.0 / cameraBaseYScale);
        
        CGFloat cameraBaseMinScale = cameraBaseYScaled / 20.0;
        CGFloat cameraBaseMaxScale = cameraBaseYScaled / 2.0;
        
        CGFloat scale = recognizer.scale;
        
        if (scale < cameraBaseMinScale)
        {
            scale = cameraBaseMinScale;
        }
        else if (scale > cameraBaseMaxScale)
        {
            scale = cameraBaseMaxScale;
        }
        
        self.cameraBaseNode.pivot = SCNMatrix4Scale(self.cameraBaseNodePivotSaved,
                                                    scale,
                                                    scale,
                                                    scale);
    }
}

- (void)viewRotated: (UIRotationGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.cameraYAngleSaved = self.cameraBaseNode.eulerAngles.y;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat cameraXZAngle = self.cameraYAngleSaved + recognizer.rotation;
        
        if (cameraXZAngle < -M_PI / 4.0)
        {
            cameraXZAngle = -M_PI / 4.0;
        }
        else if (cameraXZAngle > M_PI / 4.0)
        {
            cameraXZAngle = M_PI / 4.0;
        }
        
        self.cameraBaseNode.eulerAngles = SCNVector3Make(self.cameraBaseNode.eulerAngles.x,
                                                         cameraXZAngle,
                                                         self.cameraBaseNode.eulerAngles.z);
    }
}

- (void)drawAxes
{
    CGFloat axisRadius = 0.03;
    CGFloat axisLength = 30.0;
    
    SCNCylinder *yAxis = [SCNCylinder cylinderWithRadius: axisRadius
                                                  height: axisLength];
    
    yAxis.firstMaterial.diffuse.contents = [UIColor greenColor];
    yAxis.firstMaterial.specular.contents = [UIColor whiteColor];
    
    SCNNode *yAxisNode = [SCNNode nodeWithGeometry: yAxis];
    yAxisNode.position = SCNVector3Make(0.0, 0.0, 0.0);
    
    [self.worldNode addChildNode: yAxisNode];
    
    
    SCNCylinder *xAxis = [SCNCylinder cylinderWithRadius: axisRadius
                                                  height: axisLength];
    
    xAxis.firstMaterial.diffuse.contents = [UIColor redColor];
    xAxis.firstMaterial.specular.contents = [UIColor whiteColor];
    
    SCNNode *xAxisNode = [SCNNode nodeWithGeometry: xAxis];
    xAxisNode.position = SCNVector3Make(0.0, 0.0, 0.0);
    xAxisNode.rotation = SCNVector4Make(0.0, 0.0, 1.0, -M_PI / 2.0);
    
    [self.worldNode addChildNode: xAxisNode];
    
    
    SCNCylinder *zAxis = [SCNCylinder cylinderWithRadius: axisRadius
                                                  height: axisLength];
    
    zAxis.firstMaterial.diffuse.contents = [UIColor blueColor];
    zAxis.firstMaterial.specular.contents = [UIColor whiteColor];
    
    SCNNode *zAxisNode = [SCNNode nodeWithGeometry: zAxis];
    zAxisNode.position = SCNVector3Make(0.0, 0.0, 0.0);
    zAxisNode.rotation = SCNVector4Make(1.0, 0.0, 0.0, -M_PI / 2.0);
    
    [self.worldNode addChildNode: zAxisNode];
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

















