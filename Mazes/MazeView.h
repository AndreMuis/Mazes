//
//  MazeView.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAMaze;

typedef struct
{
	GLfloat vertCoords[12];
	GLfloat texCoords[8];
	int textureId;
} RectangleType;

typedef enum : int
{
	MAOrientationNorthSouth = 1,
	MAOrientationWestEast = 2,
	MAOrientationHorizontal = 3
} MAOrientationType;

@interface MazeView : UIView

@property (strong, nonatomic) MAMaze *maze;

@property (assign, nonatomic) float glX;
@property (assign, nonatomic) float glY;
@property (assign, nonatomic) float glZ;

@property (assign, nonatomic) float theta;

- (void)setupOpenGLViewport;
- (void)setupOpenGLTextures;
- (void)setupOpenGLVerticies;

- (void)drawMaze;
- (void)clearMaze;

- (void)translateDGLX: (float)dglx dGLY: (float)dGLY dGLZ: (float)dGLZ;
- (void)rotateDTheta: (float)dTheta;

- (void)deleteTextures;

@end





