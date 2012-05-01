//
//  MazeView.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Maze.h"
#import "Textures.h"

typedef struct
{
	GLfloat vertCoords[12];
	GLfloat texCoords[8];
	int textureId;
} rectangleType;

typedef struct
{
	int NorthSouth;
	int WestEast;
	int Horizontal;
} OrientationType;

@interface MazeView : UIView
{
	@private
	
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
	
    GLuint viewFramebuffer, viewRenderbuffer;
	GLuint depthRenderbuffer;
		
	OrientationType Orientation;
	
	GLuint *GLtextures;
	
	NSMutableArray *rectangles;
	
	float GLX, GLY, GLZ, Theta;
}

@property (nonatomic) float GLX;
@property (nonatomic) float GLY;
@property (nonatomic) float GLZ;

@property (nonatomic) float Theta;

- (void)setupOpenGLViewport;
- (void)setupOpenGLTextures;
- (void)setupOpenGLVerticies;

- (void)addRectWithX: (float)x Y: (float)y Z: (float)z
			   Width: (float)width  Length: (float)length 
		 Orientation: (int)orientation TexId: (int)texId DefaultTexId: (int)defaultTexId TexCoordsWidthPrcnt1: (float)texCoordsWidthPrcnt1 TexCoordsWidthPrcnt2: (float)texCoordsWidthPrcnt2;

- (void)drawMaze;
- (void)clearMaze;

- (void)translateDGLX: (float)dglx DGLY: (float)dgly DGLZ: (float)dglz;
- (void)rotateDTheta: (float)dtheta;

- (void)deleteTextures;

@end





