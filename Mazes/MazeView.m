//
//  MazeView.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MazeView.h"

#import "MAMaze.h"
#import "MATextureManager.h"
#import "MATexture.h"

#define USE_DEPTH_BUFFER 1

@interface MazeView ()

@property (strong, nonatomic) EAGLContext *context;

@property (assign, nonatomic) GLint backingWidth;
@property (assign, nonatomic) GLint backingHeight;

@property (assign, nonatomic) GLuint viewFramebuffer;
@property (assign, nonatomic) GLuint viewRenderbuffer;
@property (assign, nonatomic) GLuint depthRenderbuffer;

@property (assign, nonatomic) GLuint *glTextures;

@property (strong, nonatomic) NSMutableArray *rectangles;

@end

@implementation MazeView

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithCoder: (NSCoder*)coder 
{   
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
		eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        _context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
        
        if (!self.context || ![EAGLContext setCurrentContext: self.context])
		{
            return nil;
        }

		_rectangles = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void)setupOpenGLViewport
{
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	
	glDepthFunc(GL_LEQUAL);
	glClearDepthf(1.0f);
	
	glShadeModel(GL_SMOOTH);
	
	glMatrixMode(GL_PROJECTION);
	
	GLint viewportX = 0.0;
	GLint viewportY = 0.0;
	GLsizei viewportWidth = self.frame.size.width;
	GLsizei viewportHeight = self.frame.size.height;
	
	GLfloat xmin, xmax, ymin, ymax;
	GLfloat aspect = (GLfloat) viewportWidth / viewportHeight;
	GLfloat zNear = 0.01f;
	GLfloat zFar = 100.0f;
	
	ymax = zNear * tan(57.0f * (M_PI / 180.0));
	ymin = -ymax;
	xmin = ymin * aspect;
	xmax = ymax * aspect;
	
	glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
	
	glViewport(viewportX, viewportY, viewportWidth, viewportHeight);
	
	glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	
	glClearColor(1.0, 1.0, 1.0, 1.0);
}

- (void)setupOpenGLTextures
{
	self.glTextures = (GLuint *)malloc(([MATextureManager shared].maxGLId + 1) * sizeof(GLuint));
	
	glGenTextures([MATextureManager shared].maxGLId + 1, self.glTextures);

	for (MATexture *texture in [[MATextureManager shared] all])
	{		
		NSString *path = [[NSBundle mainBundle] pathForResource: texture.name ofType: @"pvrtc"];
		NSData *texData = [[NSData alloc] initWithContentsOfFile: path];
	
        // TODO
		glBindTexture(GL_TEXTURE_2D, self.glTextures[0]);
		glCompressedTexImage2D(GL_TEXTURE_2D,
                               0,
                               GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG,
                               texture.width,
                               texture.height,
                               0,
                               (texture.width * texture.height) / 2,
                               [texData bytes]);
	
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	}
}

- (void)setupOpenGLVerticies
{
	[self.rectangles removeAllObjects];
	
	// Draw Maze Rectangles
	
	// Walls
	for (MALocation *location in self.maze.locations)
	{
		float glx = (location.xx - 1) * [MAConstants shared].wallWidth;
		float glz = (location.yy - 1) * [MAConstants shared].wallWidth;
			
		// North Wall
		MAWallType wallType = [self.maze wallTypeWithLocationX: location.xx
                                                     locationY: location.yy
                                                     direction: MADirectionNorth];
		
		if (wallType == MAWallSolid || wallType == MAWallFake)
		{
			// wall far
			[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                             y: 0.0
                             z: glz
						 width: [MAConstants shared].wallWidth
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: location.wallNorthTexture.objectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
	
			// wall near
			[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth
						 width: [MAConstants shared].wallWidth
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: location.wallNorthTexture.objectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
		}
        
		// West Wall
		wallType = [self.maze wallTypeWithLocationX: location.xx
                                          locationY: location.yy
                                          direction: MADirectionWest];

		if (wallType == MAWallSolid || wallType == MAWallFake)
		{
			// wall far
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth / 2.0
						 width: [MAConstants shared].wallWidth
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: location.wallWestTexture.objectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];

			// wall near
			[self addRectWithX: glx + [MAConstants shared].wallDepth
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth / 2.0
						 width: [MAConstants shared].wallWidth
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: location.wallWestTexture.objectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
		}
        
		// Corner of North and West Wall
		
		// determine which wall segments of corner should be drawn

		// relative to corner:
		BOOL northWallExists = NO;
		BOOL southWallExists = NO;
		BOOL westWallExists = NO;
		BOOL eastWallExists = NO;
		
		MALocation *locationNorth = [self.maze locationWithLocationX: location.xx
                                                           locationY: location.yy - 1];
        
		MALocation *locationWest = [self.maze locationWithLocationX: location.xx - 1
                                                          locationY: location.yy];
		
		if (locationNorth.wallWest == MAWallSolid || locationNorth.wallWest == MAWallFake)
			northWallExists = YES;
		
		if (location.wallWest == MAWallSolid || location.wallWest == MAWallFake)
			southWallExists = YES;

		if (locationWest.wallNorth == MAWallSolid || locationWest.wallNorth == MAWallFake)
			westWallExists = YES;
		
		if (location.wallNorth == MAWallSolid || location.wallNorth == MAWallFake)
			eastWallExists = YES;
		
		BOOL topRightWallExists = NO;
		BOOL topLeftWallExists = NO;
		BOOL bottomRightWallExists = NO;
		BOOL bottomLeftWallExists = NO;
		BOOL rightTopWallExists = NO;
		BOOL rightBottomWallExists = NO;
		BOOL leftTopWallExists = NO;
		BOOL leftBottomWallExists = NO;

		if (northWallExists == YES || southWallExists == YES || westWallExists == YES || eastWallExists == YES)
		{
			topRightWallExists = YES;
			topLeftWallExists = YES;
			bottomRightWallExists = YES;
			bottomLeftWallExists = YES;
			rightTopWallExists = YES;
			rightBottomWallExists = YES;
			leftTopWallExists = YES;
			leftBottomWallExists = YES;
		}
		
		if (northWallExists == YES)
		{
			topRightWallExists = NO;
			topLeftWallExists = NO;
			rightTopWallExists = NO;
			leftTopWallExists = NO;
		}
		
		if (westWallExists == YES)
		{
			topLeftWallExists = NO;
			bottomLeftWallExists = NO;
			leftTopWallExists = NO;
			leftBottomWallExists = NO;
		}
		
		if (eastWallExists == YES)
		{
			topRightWallExists = NO;
			bottomRightWallExists = NO;
			rightTopWallExists = NO;
			rightBottomWallExists = NO;
		}
		
		if (southWallExists == YES)
		{
			bottomRightWallExists = NO;
			bottomLeftWallExists = NO;
			rightBottomWallExists = NO;
			leftBottomWallExists = NO;
		}
		
		// textures
		
		NSString *northWallTextureObjectId = locationNorth.wallWestTexture.objectId;
		NSString *westWallTextureObjectId = locationWest.wallNorthTexture.objectId;
		NSString *eastWallTextureObjectId = location.wallNorthTexture.objectId;
		NSString *southWallTextureObjectId = location.wallWestTexture.objectId;
		
		NSString *topRightWallTextureObjectId = northWallTextureObjectId;
		NSString *topLeftWallTextureObjectId = northWallTextureObjectId;
		NSString *bottomRightWallTextureObjectId = southWallTextureObjectId;
		NSString *bottomLeftWallTextureObjectId = southWallTextureObjectId;
		NSString *rightTopWallTextureObjectId = eastWallTextureObjectId;
		NSString *rightBottomWallTextureObjectId = eastWallTextureObjectId;
		NSString *leftTopWallTextureObjectId = westWallTextureObjectId;
		NSString *leftBottomWallTextureObjectId = westWallTextureObjectId;
				
		if (northWallExists == YES && westWallExists == NO && eastWallExists == NO && southWallExists == NO)
		{
			topRightWallTextureObjectId = location.wallWestTexture.objectId;
			topLeftWallTextureObjectId = location.wallWestTexture.objectId;
			rightTopWallTextureObjectId = location.wallWestTexture.objectId;
			leftTopWallTextureObjectId = location.wallWestTexture.objectId;
		}
		else if (northWallExists == NO && westWallExists == YES && eastWallExists == NO && southWallExists == NO)
		{
			topLeftWallTextureObjectId = location.wallNorthTexture.objectId;
			bottomLeftWallTextureObjectId = location.wallNorthTexture.objectId;
			leftTopWallTextureObjectId = location.wallNorthTexture.objectId;
			leftBottomWallTextureObjectId = location.wallNorthTexture.objectId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == YES && southWallExists == NO)
		{
			topRightWallTextureObjectId = locationWest.wallNorthTexture.objectId;
			bottomRightWallTextureObjectId = locationWest.wallNorthTexture.objectId;
			rightTopWallTextureObjectId = locationWest.wallNorthTexture.objectId;
			rightBottomWallTextureObjectId = locationWest.wallNorthTexture.objectId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == NO && southWallExists == YES)
		{
			bottomRightWallTextureObjectId = locationNorth.wallWestTexture.objectId;
			bottomLeftWallTextureObjectId = locationNorth.wallWestTexture.objectId;
			rightBottomWallTextureObjectId = locationNorth.wallWestTexture.objectId;
			leftBottomWallTextureObjectId = locationNorth.wallWestTexture.objectId;
		}
		else if (northWallExists == YES && westWallExists == NO && eastWallExists == YES && southWallExists == NO)
		{
			leftBottomWallTextureObjectId = northWallTextureObjectId;
			bottomLeftWallTextureObjectId = eastWallTextureObjectId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == YES && southWallExists == YES)
		{
			leftTopWallTextureObjectId = southWallTextureObjectId;
			topLeftWallTextureObjectId = eastWallTextureObjectId;
		}
		else if (northWallExists == NO && westWallExists == YES && eastWallExists == NO && southWallExists == YES)
		{
			rightTopWallTextureObjectId = southWallTextureObjectId;
			topRightWallTextureObjectId = westWallTextureObjectId;
		}
		else if (northWallExists == YES && westWallExists == YES && eastWallExists == NO && southWallExists == NO)
		{
			rightBottomWallTextureObjectId = northWallTextureObjectId;
			bottomRightWallTextureObjectId = westWallTextureObjectId;
		}
		
		float wallWidthPrcnt = ([MAConstants shared].wallDepth / 2.0) / [MAConstants shared].wallWidth;
		
		if (topLeftWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: topLeftWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			

		if (topRightWallExists == YES)
		{
			[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                             y: 0.0
                             z: glz
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: topRightWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (bottomLeftWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: bottomLeftWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (bottomRightWallExists == YES)
		{
			[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationWestEast
                   texObjectId: bottomRightWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (leftTopWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: leftTopWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (leftBottomWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth / 2.0
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: leftBottomWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (rightTopWallExists == YES)
		{
			[self addRectWithX: glx + [MAConstants shared].wallDepth
                             y: 0.0
                             z: glz
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: rightTopWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (rightBottomWallExists == YES)
		{
			[self addRectWithX: glx + [MAConstants shared].wallDepth
                             y: 0.0
                             z: glz + [MAConstants shared].wallDepth / 2.0
						 width: [MAConstants shared].wallDepth / 2.0
                        length: [MAConstants shared].wallHeight
				   orientation: MAOrientationNorthSouth
                   texObjectId: rightBottomWallTextureObjectId
            defaultTexObjectId: self.maze.wallTexture.objectId
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}
	}		
		
	// Floor
	for (MALocation *location in self.maze.locations)
	{
		float glx = (location.xx - 1) * [MAConstants shared].wallWidth;
		float glz = (location.yy - 1) * [MAConstants shared].wallWidth;
		
		[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                         y: 0.0
                         z: glz + [MAConstants shared].wallDepth / 2.0
					 width: [MAConstants shared].wallWidth
                    length: [MAConstants shared].wallWidth
			   orientation: MAOrientationHorizontal
               texObjectId: location.floorTexture.objectId
        defaultTexObjectId: self.maze.floorTexture.objectId
      texCoordsWidthPrcnt1: 0.0
      texCoordsWidthPrcnt2: 1.0];
	}
	
	// Ceiling
	for (MALocation *location in self.maze.locations)
	{
		float glx = (location.xx - 1) * [MAConstants shared].wallWidth;
		float glz = (location.yy - 1) * [MAConstants shared].wallWidth;

		[self addRectWithX: glx + [MAConstants shared].wallDepth / 2.0
                         y: [MAConstants shared].wallHeight
                         z: glz + [MAConstants shared].wallDepth / 2.0
					 width: [MAConstants shared].wallWidth
                    length: [MAConstants shared].wallWidth
			   orientation: MAOrientationHorizontal
               texObjectId: location.ceilingTexture.objectId
        defaultTexObjectId: self.maze.ceilingTexture.objectId
      texCoordsWidthPrcnt1: 0.0
      texCoordsWidthPrcnt2: 1.0];
 	}
	
	//int verticiesCount = wallVerticiesCount + floorVerticiesCount + ceilingVerticiesCount + startVerticiesCount + endVerticiesCount;
	//NSLog(@"verticies = %d", verticiesCount);
	//NSLog(@"recyanles = %d", verticiesCount / 4);
	//NSLog(@"GL triangles = %d", verticiesCount / 2);
	//NSLog(@"GL verticies coordinates = %d", verticiesCount * 3);
}

- (void)addRectWithX: (float)x
                   y: (float)y
                   z: (float)z
			   width: (float)width
              length: (float)length
		 orientation: (MAOrientationType)orientation
         texObjectId: (NSString *)texObjectId
  defaultTexObjectId: (NSString *)defaultTexObjectId
texCoordsWidthPrcnt1: (float)texCoordsWidthPrcnt1
texCoordsWidthPrcnt2: (float)texCoordsWidthPrcnt2
{
	if (texObjectId == nil)
    {
		texObjectId = defaultTexObjectId;
	}
    
	RectangleType rectangle;
	
    // TODO
    rectangle.textureId = 0; // texId;
	
	float x1 = 0.0, y1 = 0.0, z1 = 0.0, x2 = 0.0, y2 = 0.0, z2 = 0.0;
	
	if (orientation == MAOrientationWestEast)
	{
		x1 = x;
		x2 = x + width;
		
		y1 = y;
		y2 = y + length;
		
		z1 = z;
		
		rectangle.vertCoords[0] = x2;
		rectangle.vertCoords[1] = y1;
		rectangle.vertCoords[2] = z1;
		
		rectangle.vertCoords[3] = x2;
		rectangle.vertCoords[4] = y2;
		rectangle.vertCoords[5] = z1;
		
		rectangle.vertCoords[6] = x1;
		rectangle.vertCoords[7] = y1;
		rectangle.vertCoords[8] = z1;
		
		rectangle.vertCoords[9] = x1;
		rectangle.vertCoords[10] = y2;
		rectangle.vertCoords[11] = z1;
	}
	else if (orientation == MAOrientationNorthSouth)
	{
		x1 = x;
		
		y1 = y;
		y2 = y + length;
		
		z1 = z;
		z2 = z + width;
		
		rectangle.vertCoords[0] = x1; 
		rectangle.vertCoords[1] = y1; 
		rectangle.vertCoords[2] = z2; 

		rectangle.vertCoords[3] = x1; 
		rectangle.vertCoords[4] = y2; 
		rectangle.vertCoords[5] = z2; 

		rectangle.vertCoords[6] = x1; 
		rectangle.vertCoords[7] = y1; 
		rectangle.vertCoords[8] = z1; 

		rectangle.vertCoords[9] = x1; 
		rectangle.vertCoords[10] = y2; 
		rectangle.vertCoords[11] = z1; 		
	}
	else if (orientation == MAOrientationHorizontal)
	{
		x1 = x;
		x2 = x + length;
		
		y1 = y;
		
		z1 = z;
		z2 = z + width;
		
		rectangle.vertCoords[0] = x2; 
		rectangle.vertCoords[1] = y1; 
		rectangle.vertCoords[2] = z2; 
		
		rectangle.vertCoords[3] = x2; 
		rectangle.vertCoords[4] = y1; 
		rectangle.vertCoords[5] = z1; 
		
		rectangle.vertCoords[6] = x1; 
		rectangle.vertCoords[7] = y1; 
		rectangle.vertCoords[8] = z2; 
		
		rectangle.vertCoords[9] = x1; 
		rectangle.vertCoords[10] = y1; 
		rectangle.vertCoords[11] = z1; 		
	}
    
    // TODO
	MATexture *texture = [[MATextureManager shared] textureWithObjectId: @""];
	
	rectangle.texCoords[0] = texture.repeats * texCoordsWidthPrcnt2;
	rectangle.texCoords[1] = texture.repeats;
	
	rectangle.texCoords[2] = texture.repeats * texCoordsWidthPrcnt2;
	rectangle.texCoords[3] = 0.0;
	
	rectangle.texCoords[4] = texture.repeats * texCoordsWidthPrcnt1;
	rectangle.texCoords[5] = texture.repeats;
	
	rectangle.texCoords[6] = texture.repeats * texCoordsWidthPrcnt1;
	rectangle.texCoords[7] = 0.0;	
	
	NSData *data = [[NSData alloc] initWithBytes: &rectangle length: sizeof(RectangleType)];
	
	[self.rectangles addObject: data];
}
		 
- (void)drawMaze
{
	[EAGLContext setCurrentContext: self.context];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	int currTextureId = -1;
	
	for (NSData *data in self.rectangles)
	{	
		RectangleType rectangle;
		[data getBytes: &rectangle length: sizeof(RectangleType)];
	
		glVertexPointer(3, GL_FLOAT, 0, rectangle.vertCoords);
		glTexCoordPointer(2, GL_FLOAT, 0, rectangle.texCoords);
	
		if (rectangle.textureId != currTextureId)
		{
			currTextureId = rectangle.textureId;
			
			glBindTexture(GL_TEXTURE_2D, self.glTextures[rectangle.textureId]);
		}
		
		// draw single rectangle
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);	
	
    [self.context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void)clearMaze
{
	[EAGLContext setCurrentContext: self.context];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.viewFramebuffer);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.viewRenderbuffer);	
	
    [self.context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

- (void)translateDGLX: (float)dGLX dGLY: (float)dGLY dGLZ: (float)dGLZ
{
	glTranslatef(-dGLX, -dGLY, -dGLZ);
	
	self.glX = self.glX + dGLX;
	self.glY = self.glY + dGLY;
	self.glZ = self.glZ + dGLZ;
}

- (void)rotateDTheta: (float)dTheta
{
	glTranslatef(self.glX, 0.0, self.glZ);
	
	glRotatef(dTheta, 0.0f, 1.0f, 0.0f);
	
	glTranslatef(-self.glX, 0.0, -self.glZ);
	
	self.theta = self.theta + dTheta;
}
	
- (void)layoutSubviews 
{
    [EAGLContext setCurrentContext: self.context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawMaze];
}

- (BOOL)createFramebuffer 
{    
    glGenFramebuffersOES(1, &_viewFramebuffer);
    glGenRenderbuffersOES(1, &_viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
    
    if (USE_DEPTH_BUFFER) 
	{
        glGenRenderbuffersOES(1, &_depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) 
	{
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFramebuffer 
{    
    glDeleteFramebuffersOES(1, &_viewFramebuffer);
    _viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
    _viewRenderbuffer = 0;
    
    if(_depthRenderbuffer)
	{
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
}

- (void)deleteTextures;
{
	glDeleteTextures([MATextureManager shared].maxGLId + 1, self.glTextures);
}

@end
