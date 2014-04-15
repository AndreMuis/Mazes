//
//  MAMazeView.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAMazeView.h"

#import "MAMaze.h"
#import "MATextureManager.h"
#import "MATexture.h"
#import "MAWall.h"
#import "MAUtilities.h"

#define USE_DEPTH_BUFFER 1

@interface MAMazeView ()

@property (strong, nonatomic) EAGLContext *context;

@property (assign, nonatomic) GLint backingWidth;
@property (assign, nonatomic) GLint backingHeight;

@property (assign, nonatomic) GLuint viewFramebuffer;
@property (assign, nonatomic) GLuint viewRenderbuffer;
@property (assign, nonatomic) GLuint depthRenderbuffer;

@property (assign, nonatomic) GLuint *glTextures;

@property (strong, nonatomic) NSMutableArray *rectangles;

@end

@implementation MAMazeView

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
	
	ymax = zNear * tan([MAUtilities radiansFromDegrees: 57.0]);
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
	self.glTextures = (GLuint *)malloc([self.textureManager all].count * sizeof(GLuint));
	
	glGenTextures([self.textureManager all].count, self.glTextures);

	for (NSUInteger i = 0; i < [self.textureManager all].count; i = i + 1)
    {
        MATexture *texture = [[self.textureManager all] objectAtIndex: i];

		NSString *path = [[NSBundle mainBundle] pathForResource: texture.name ofType: @"pvrtc"];
		NSData *texData = [[NSData alloc] initWithContentsOfFile: path];
	
		glBindTexture(GL_TEXTURE_2D, self.glTextures[i]);
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
	
	// walls
	for (MAWall *wall in [self.maze allWalls])
	{
		float glx = (wall.column - 1) * MAWallWidth;
		float glz = (wall.row - 1) * MAWallWidth;
			
        if (wall.direction == MADirectionNorth &&
            (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake))
        {
            // wall far
            [self addRectWithX: glx + MAWallDepth / 2.0
                             y: 0.0
                             z: glz
                         width: MAWallWidth
                        length: MAWallHeight
                   orientation: MAOrientationWestEast
                     textureId: wall.textureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
    
            // wall near
            [self addRectWithX: glx + MAWallDepth / 2.0
                             y: 0.0
                             z: glz + MAWallDepth
                         width: MAWallWidth
                        length: MAWallHeight
                   orientation: MAOrientationWestEast
                     textureId: wall.textureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
        }
        else if (wall.direction == MADirectionWest &&
                 (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake))
		{
			// wall far
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + MAWallDepth / 2.0
						 width: MAWallWidth
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: wall.textureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];

			// wall near
			[self addRectWithX: glx + MAWallDepth
                             y: 0.0
                             z: glz + MAWallDepth / 2.0
						 width: MAWallWidth
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: wall.textureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: 1.0];
		}
    }
    
    // corner of north and west wall
    // determine which wall segments of corner should be drawn
    for (MALocation *location in [self.maze allLocations])
	{
        float glx = (location.column - 1) * MAWallWidth;
		float glz = (location.row - 1) * MAWallWidth;
        
		// relative to corner:
		BOOL northWallExists = NO;
		BOOL southWallExists = NO;
		BOOL westWallExists = NO;
		BOOL eastWallExists = NO;
		   
        MAWall *northWall = nil;
        if ([self.maze isValidWallWithRow: location.row - 1
                                   column: location.column
                                direction: MADirectionWest] == YES)
        {
            northWall = [self.maze wallWithRow: location.row - 1
                                        column: location.column
                                     direction: MADirectionWest];

            if (northWall.type == MAWallSolid || northWall.type == MAWallBorder || northWall.type == MAWallFake)
            {
                northWallExists = YES;
            }
        }
        
		MAWall *southWall = nil;
        if ([self.maze isValidWallWithRow: location.row
                                   column: location.column
                                direction: MADirectionWest] == YES)
        {
            southWall = [self.maze wallWithRow: location.row
                                        column: location.column
                                     direction: MADirectionWest];
           
            if (southWall.type == MAWallSolid || southWall.type == MAWallBorder || southWall.type == MAWallFake)
            {
                southWallExists = YES;
            }
        }
        
        MAWall *westWall = nil;
        if ([self.maze isValidWallWithRow: location.row
                                   column: location.column - 1
                                direction: MADirectionNorth] == YES)
        {
            westWall = [self.maze wallWithRow: location.row
                                       column: location.column - 1
                                    direction: MADirectionNorth];
            
            
            if (westWall.type == MAWallSolid || westWall.type == MAWallBorder || westWall.type == MAWallFake)
            {
                westWallExists = YES;
            }
        }
        
        MAWall *eastWall = nil;
        if ([self.maze isValidWallWithRow: location.row
                                   column: location.column
                                direction: MADirectionNorth] == YES)
        {
            eastWall = [self.maze wallWithRow: location.row
                                       column: location.column
                                    direction: MADirectionNorth];
            
            if (eastWall.type == MAWallSolid || eastWall.type == MAWallBorder || eastWall.type == MAWallFake)
            {
                eastWallExists = YES;
            }
        }
        
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
		
		NSString *topRightWallTextureId = northWall.textureId;
		NSString *topLeftWallTextureId = northWall.textureId;
		NSString *bottomRightWallTextureId = southWall.textureId;
		NSString *bottomLeftWallTextureId = southWall.textureId;
		NSString *rightTopWallTextureId = eastWall.textureId;
		NSString *rightBottomWallTextureId = eastWall.textureId;
		NSString *leftTopWallTextureId = westWall.textureId;
		NSString *leftBottomWallTextureId = westWall.textureId;
				
		if (northWallExists == YES && westWallExists == NO && eastWallExists == NO && southWallExists == NO)
		{
			bottomRightWallTextureId = northWall.textureId;
			bottomLeftWallTextureId = northWall.textureId;
			rightBottomWallTextureId = northWall.textureId;
			leftBottomWallTextureId = northWall.textureId;
		}
		else if (northWallExists == NO && westWallExists == YES && eastWallExists == NO && southWallExists == NO)
		{
			topRightWallTextureId = westWall.textureId;
			bottomRightWallTextureId = westWall.textureId;
			rightTopWallTextureId = westWall.textureId;
			rightBottomWallTextureId = westWall.textureId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == YES && southWallExists == NO)
		{
			topLeftWallTextureId = eastWall.textureId;
			bottomLeftWallTextureId = eastWall.textureId;
			leftTopWallTextureId = eastWall.textureId;
			leftBottomWallTextureId = eastWall.textureId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == NO && southWallExists == YES)
		{
			topRightWallTextureId = southWall.textureId;
			topLeftWallTextureId = southWall.textureId;
			rightTopWallTextureId = southWall.textureId;
			leftTopWallTextureId = southWall.textureId;
		}
		else if (northWallExists == YES && westWallExists == NO && eastWallExists == YES && southWallExists == NO)
		{
			leftBottomWallTextureId = northWall.textureId;
			bottomLeftWallTextureId = eastWall.textureId;
		}
		else if (northWallExists == NO && westWallExists == NO && eastWallExists == YES && southWallExists == YES)
		{
			leftTopWallTextureId = southWall.textureId;
			topLeftWallTextureId = eastWall.textureId;
		}
		else if (northWallExists == NO && westWallExists == YES && eastWallExists == NO && southWallExists == YES)
		{
			rightTopWallTextureId = southWall.textureId;
			topRightWallTextureId = westWall.textureId;
		}
		else if (northWallExists == YES && westWallExists == YES && eastWallExists == NO && southWallExists == NO)
		{
			rightBottomWallTextureId = northWall.textureId;
			bottomRightWallTextureId = westWall.textureId;
		}
		
		float wallWidthPrcnt = (MAWallDepth / 2.0) / MAWallWidth;
		
		if (topLeftWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationWestEast
                     textureId: topLeftWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			

		if (topRightWallExists == YES)
		{
			[self addRectWithX: glx + MAWallDepth / 2.0
                             y: 0.0
                             z: glz
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationWestEast
                     textureId: topRightWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (bottomLeftWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + MAWallDepth
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationWestEast
                     textureId: bottomLeftWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (bottomRightWallExists == YES)
		{
			[self addRectWithX: glx + MAWallDepth / 2.0
                             y: 0.0
                             z: glz + MAWallDepth
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationWestEast
                     textureId: bottomRightWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (leftTopWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: leftTopWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (leftBottomWallExists == YES)
		{
			[self addRectWithX: glx
                             y: 0.0
                             z: glz + MAWallDepth / 2.0
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: leftBottomWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}			
		
		if (rightTopWallExists == YES)
		{
			[self addRectWithX: glx + MAWallDepth
                             y: 0.0
                             z: glz
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: rightTopWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 1.0 - wallWidthPrcnt
          texCoordsWidthPrcnt2: 1.0];
		}			
		
		if (rightBottomWallExists == YES)
		{
			[self addRectWithX: glx + MAWallDepth
                             y: 0.0
                             z: glz + MAWallDepth / 2.0
						 width: MAWallDepth / 2.0
                        length: MAWallHeight
				   orientation: MAOrientationNorthSouth
                     textureId: rightBottomWallTextureId
                defaultTexture: self.maze.wallTexture
          texCoordsWidthPrcnt1: 0.0
          texCoordsWidthPrcnt2: wallWidthPrcnt];
		}
	}		
		
	// floor
	for (MALocation *location in [self.maze allLocations])
	{
		float glx = (location.column - 1) * MAWallWidth;
		float glz = (location.row - 1) * MAWallWidth;
		
		[self addRectWithX: glx + MAWallDepth / 2.0
                         y: 0.0
                         z: glz + MAWallDepth / 2.0
					 width: MAWallWidth
                    length: MAWallWidth
			   orientation: MAOrientationHorizontal
                 textureId: location.floorTextureId
            defaultTexture: self.maze.floorTexture
      texCoordsWidthPrcnt1: 0.0
      texCoordsWidthPrcnt2: 1.0];
	}
	
	// ceiling
	for (MALocation *location in [self.maze allLocations])
	{
		float glx = (location.column - 1) * MAWallWidth;
		float glz = (location.row - 1) * MAWallWidth;

		[self addRectWithX: glx + MAWallDepth / 2.0
                         y: MAWallHeight
                         z: glz + MAWallDepth / 2.0
					 width: MAWallWidth
                    length: MAWallWidth
			   orientation: MAOrientationHorizontal
                 textureId: location.ceilingTextureId
            defaultTexture: self.maze.ceilingTexture
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
           textureId: (NSString *)textureId
      defaultTexture: (MATexture *)defaultTexture
texCoordsWidthPrcnt1: (float)texCoordsWidthPrcnt1
texCoordsWidthPrcnt2: (float)texCoordsWidthPrcnt2
{
    MATexture *texture = nil;
    
    if (textureId == nil)
    {
		texture = defaultTexture;
    }
	else
    {
        texture = [self.textureManager textureWithTextureId: textureId];
	}
    
	RectangleType rectangle;
	
    rectangle.textureId = [[self.textureManager all] indexOfObject: texture];
	
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

- (void)deleteTextures
{
	glDeleteTextures([self.textureManager all].count, self.glTextures);
}

@end
