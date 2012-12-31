//
//  MazeView.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Maze;

typedef struct
{
	GLfloat vertCoords[12];
	GLfloat texCoords[8];
	int textureId;
} RectangleType;

typedef enum
{
	MAOrientationNorthSouth = 1,
	MAOrientationWestEast = 2,
	MAOrientationHorizontal = 3
} MAOrientationType;

@interface MazeView : UIView
{
    GLint backingWidth;
    GLint backingHeight;
    
    GLuint viewFramebuffer;
    GLuint viewRenderbuffer;
	GLuint depthRenderbuffer;
		
	GLuint *glTextures;
	
	NSMutableArray *rectangles;
}

@property (strong, nonatomic) Maze *maze;

@property (assign, nonatomic) float glX;
@property (assign, nonatomic) float glY;
@property (assign, nonatomic) float glZ;

@property (assign, nonatomic) float theta;

- (void)setupOpenGLViewport;
- (void)setupOpenGLTextures;
- (void)setupOpenGLVerticies;

- (void)addRectWithX: (float)x
                   y: (float)y
                   z: (float)z
			   width: (float)width
              length: (float)length
		 orientation: (MAOrientationType)orientation
               texId: (int)texId
        defaultTexId: (int)defaultTexId
texCoordsWidthPrcnt1: (float)texCoordsWidthPrcnt1
texCoordsWidthPrcnt2: (float)texCoordsWidthPrcnt2;

- (void)drawMaze;
- (void)clearMaze;

- (void)translateDGLX: (float)dglx dGLY: (float)dGLY dGLZ: (float)dGLZ;
- (void)rotateDTheta: (float)dTheta;

- (void)deleteTextures;

@end





