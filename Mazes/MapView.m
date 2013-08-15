//
//  MapView.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MapView.h"

#import "MALocation.h"
#import "MAMaze.h"
#import "MAUtilities.h"
#import "MapSegment.h"
#import "Styles.h"

@interface MapView ()

@property (strong, nonatomic) NSMutableArray *segments;
@property (strong, nonatomic) UIImageView *directionArrowImageView;

@end

@implementation MapView

int MapWalls[17][3][3] = 
{
	{{-1, 0, MADirectionSouth}, {-1, 0, MADirectionEast}, {0, 0, 0}},
	{{0, 0, MADirectionSouth}, {0, 0, 0}, {0, 0, 0}},
	{{1, 0, MADirectionSouth}, {1, 0, MADirectionWest}, {0, 0, 0}},
	
	{{0, 0, MADirectionWest}, {0, 0, 0}, {0, 0, 0}},
	{{0, 0, MADirectionNorth}, {0, 0, 0}, {0, 0, 0}},
	{{0, 0, MADirectionEast}, {0, 0, 0}, {0, 0, 0}},
	
	{{-1, 0, MADirectionWest}, {0, 0, MADirectionWest}, {0, 0, 0}},
	{{-1, 0, MADirectionNorth}, {0, 0, MADirectionWest}, {0, 0, 0}},
	{{0, -1, MADirectionWest}, {0, -1, MADirectionSouth}, {0, 0, 0}},
	{{0, -1, MADirectionNorth}, {0, -1, MADirectionSouth}, {0, 0, 0}},
	{{0, -1, MADirectionEast}, {0, -1, MADirectionSouth}, {0, 0, 0}},
	{{1, 0, MADirectionNorth}, {0, 0, MADirectionEast}, {0, 0, 0}},
	{{1, 0, MADirectionEast}, {0, 0, MADirectionEast}, {0, 0, 0}},
	
	{{-1, -1, MADirectionWest}, {-1, -1, MADirectionSouth}, {0, 0, MADirectionWest}},
	{{-1, -1, MADirectionNorth}, {-1, -1, MADirectionEast}, {0, 0, MADirectionNorth}},
	{{1, -1, MADirectionNorth}, {1, -1, MADirectionWest}, {0, 0, MADirectionNorth}},
	{{1, -1, MADirectionEast}, {1, -1, MADirectionSouth}, {0, 0, MADirectionEast}},
};

int MapSquares[8][3][3] = 
{
	{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
	{{-1, 0, 0}, {0, 0, MADirectionWest}, {0, 0, 0}},
	{{-1, -1, 0}, {-1, 0, MADirectionNorth}, {0, 0, MADirectionWest}},
	{{-1, -1, 0}, {0, -1, MADirectionWest}, {0, 0, MADirectionNorth}},
	{{0, -1, 0}, {0, 0, MADirectionNorth}, {0, 0, 0}},
	{{1, -1, 0}, {0, -1, MADirectionEast}, {0, 0, MADirectionNorth}},
	{{1, -1, 0}, {1, 0, MADirectionNorth}, {0, 0, MADirectionEast}},
	{{1, 0, 0}, {0, 0, MADirectionEast}, {0, 0, 0}}
};

- (id)initWithCoder: (NSCoder*)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        _segments = [[NSMutableArray alloc] init];
        
		UIImage *directionArrowImage = [MAUtilities createDirectionArrowImageWidth: [Styles shared].map.squareWidth
                                                                          height: [Styles shared].map.squareWidth];
		
		_directionArrowImageView = [[UIImageView alloc] initWithImage: directionArrowImage];
		_directionArrowImageView.alpha = 0.0;
		
		[self addSubview: self.directionArrowImageView];
    }
	
	return self;
}

- (void)drawSurroundings
{
	BOOL visible = NO;
	
	float xOffset = ([Styles shared].map.length - ([Styles shared].map.squareWidth * self.maze.columns + [Styles shared].map.wallWidth * (self.maze.columns + 1))) / 2.0;
	float yOffset = ([Styles shared].map.length - ([Styles shared].map.squareWidth * self.maze.rows + [Styles shared].map.wallWidth * (self.maze.rows + 1))) / 2.0;
	
	CGPoint offset = CGPointMake(xOffset, yOffset);
	
	// Map Walls
	
	int wallLocX = 0;
    int wallLocY = 0;

    MADirectionType wallDir = MADirectionUnknown;

	int wallStartX = 0;
    int wallStartY = 0;
    int wallWidth = 0;
    int wallHeight = 0;
	
    MAWallType wallType = MAWallUnknown;
	UIColor *wallColor = nil;
	
	for (int i = 0; i < 17; i = i + 1)
	{
		visible = YES;
		
		for (int j = 1; j < 3; j = j + 1)
		{
			[self rotateCoordinatesX: MapWalls[i][j][0] y: MapWalls[i][j][1] dir: MapWalls[i][j][2] rx: &wallLocX ry: &wallLocY rdir: &wallDir];
			
			// only consider rows with directions specified
			if (MapWalls[i][j][2] != 0)
			{
				wallType = [self.maze wallTypeWithLocationX: self.currLoc.xx + wallLocX
                                                  locationY: self.currLoc.yy + wallLocY
                                                  direction: wallDir];
                
				if (wallType == MAWallSolid || wallType == MAWallFake)
                {
					visible = NO;
                }
			}
		}
		
		// NSLog(@"i = %d, visible = %d", i, visible);
		
		if (visible == YES)
		{
			[self rotateCoordinatesX: MapWalls[i][0][0] y: MapWalls[i][0][1] dir: MapWalls[i][0][2] rx: &wallLocX ry: &wallLocY rdir: &wallDir];
			
			// get drawing location where the wall is North or West
			MALocation *drawLoc = nil;
			if (wallDir == MADirectionNorth || wallDir == MADirectionWest)
			{
				drawLoc = [self.maze locationWithLocationX: self.currLoc.xx + wallLocX
                                                 locationY: self.currLoc.yy + wallLocY];
			}
			else if (wallDir == MADirectionSouth)
			{
				drawLoc = [self.maze locationWithLocationX: self.currLoc.xx + wallLocX
                                                 locationY: self.currLoc.yy + wallLocY + 1];
				wallDir = MADirectionNorth;
			}	
			else if (wallDir == MADirectionEast)
			{
				drawLoc = [self.maze locationWithLocationX: self.currLoc.xx + wallLocX + 1
                                                 locationY: self.currLoc.yy + wallLocY];
				wallDir = MADirectionWest;
			}	
			
			// draw wall
			wallType = [self.maze wallTypeWithLocationX: drawLoc.xx
                                              locationY: drawLoc.yy
                                              direction: wallDir];
			
			if (wallDir == MADirectionNorth)
			{
				wallStartX = offset.x + (drawLoc.xx - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
				wallStartY = offset.y + (drawLoc.yy - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
				
				wallWidth = [Styles shared].map.squareWidth;
				wallHeight = [Styles shared].map.wallWidth;
			}
			else if (wallDir == MADirectionWest)
			{
				wallStartX = offset.x + (drawLoc.xx - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
				wallStartY = offset.y + (drawLoc.yy - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
				
				wallWidth = [Styles shared].map.wallWidth;
				wallHeight = [Styles shared].map.squareWidth;
			}
			
			if (wallType == MAWallSolid || wallType == MAWallFake)
			{				
				wallColor = [Styles shared].map.wallColor;
			}
			else if (wallType == MAWallInvisible && [self.maze hasHitWallWithLocationX: drawLoc.xx
                                                                             locationY: drawLoc.yy
                                                                             direction: wallDir] == YES)
			{
				wallColor = [Styles shared].map.invisibleColor;
			}
			else if (wallType == MAWallNone || wallType == MAWallInvisible)
			{
				wallColor = [Styles shared].map.noWallColor;
			}
			
			[self addSegmentRect: CGRectMake(wallStartX, wallStartY, wallWidth, wallHeight) color: wallColor];
			
			MALocation *cornerLoc = nil;
			
			// draw corners on either side of wall
			if (wallDir == MADirectionNorth)
			{
				cornerLoc = drawLoc;
				[self drawCornerWithLocation: cornerLoc offset: offset];
				
				cornerLoc = [self.maze locationWithLocationX: drawLoc.xx + 1
                                                   locationY: drawLoc.yy];
                
				[self drawCornerWithLocation: cornerLoc offset: offset];
			}
			else if (wallDir == MADirectionWest)
			{
				cornerLoc = drawLoc;
				[self drawCornerWithLocation: cornerLoc offset: offset];
				
				cornerLoc = [self.maze locationWithLocationX: drawLoc.xx
                                                   locationY: drawLoc.yy + 1];
                
				[self drawCornerWithLocation: cornerLoc offset: offset];
			}
		}
	}	
	
	// Map Squares
	
	int squareX = 0;
    int squareY = 0;
    
	int squareStartX = 0;
    int squareStartY = 0;
    int squareWidth = 0;
    int squareHeight = 0;
	
    UIColor *squareColor = nil;
	
	for (int i = 0; i < 8; i = i + 1)
	{
		visible = YES;
		
		for (int j = 1; j < 3; j = j + 1)
		{
			[self rotateCoordinatesX: MapSquares[i][j][0] y: MapSquares[i][j][1] dir: MapSquares[i][j][2] rx: &squareX ry: &squareY rdir: &wallDir];
			
			if (MapSquares[i][j][2] != 0)
			{
				wallType = [self.maze wallTypeWithLocationX: self.currLoc.xx + squareX
                                                  locationY: self.currLoc.yy + squareY
                                                  direction: wallDir];
                
				if (wallType == MAWallSolid || wallType == MAWallFake)
                {
					visible = NO;
                }
			}
		}
		
		if (visible == YES)
		{
			[self rotateCoordinatesX: MapSquares[i][0][0] y: MapSquares[i][0][1] dir: MapSquares[i][0][2] rx: &squareX ry: &squareY rdir: &wallDir];
			
			MALocation *drawLoc = [self.maze locationWithLocationX: self.currLoc.xx + squareX
                                                         locationY: self.currLoc.yy + squareY];
			
			squareStartX = offset.x + (drawLoc.xx - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
			squareStartY = offset.y + (drawLoc.yy - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
			
			squareWidth = [Styles shared].map.squareWidth;
			squareHeight = [Styles shared].map.squareWidth;
			
			if (drawLoc.action == MALocationActionStart)
            {
				squareColor = [Styles shared].map.startColor;
            }
			else if (drawLoc.action == MALocationActionEnd)
            {
				squareColor = [Styles shared].map.endColor;
            }
			else if (drawLoc.action == MALocationActionStartOver && drawLoc.visited == YES)
            {
				squareColor = [Styles shared].map.startOverColor;
            }
			else if (drawLoc.action == MALocationActionTeleport && drawLoc.visited == YES)
            {
				squareColor = [Styles shared].map.teleportationColor;
            }
			else
            {
				squareColor = [Styles shared].map.doNothingColor;
            }
			
			[self addSegmentRect: CGRectMake(squareStartX, squareStartY, squareWidth, squareHeight) color: squareColor];
		}
	}
	
	// Draw map
	[self setNeedsDisplay];
	
	// Draw directional arrow
	if (self.directionArrowImageView.alpha == 0.0)
    {
		self.directionArrowImageView.alpha = 1.0;
	}
    
	float arrowX = offset.x + (self.currLoc.xx - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
	float arrowY = offset.y + (self.currLoc.yy - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
	
	self.directionArrowImageView.frame = CGRectMake(arrowX, arrowY, [Styles shared].map.squareWidth, [Styles shared].map.squareWidth);
	
	float theta = 0.0;
	if (self.currDir == MADirectionNorth) theta = 0.0;
	if (self.currDir == MADirectionEast) theta = 90.0;
	if (self.currDir == MADirectionSouth) theta = 180.0;
	if (self.currDir == MADirectionWest) theta = 270.0;
	[MAUtilities rotateImageView: self.directionArrowImageView angleDegrees: theta];
}

// corner is at top-left of location
- (void)drawCornerWithLocation: (MALocation *)cornerLoc offset: (CGPoint)offset
{
	int cornerStartX = offset.x + (cornerLoc.xx - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
	int cornerStartY = offset.y + (cornerLoc.yy - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
	
	int cornerWidth = [Styles shared].map.wallWidth;
	int cornerHeight = [Styles shared].map.wallWidth;
	
	UIColor *cornerColor = nil;
	
	// relative to corner
	MAWallType wallTypeNorth = [self.maze wallTypeWithLocationX: cornerLoc.xx
                                                      locationY: cornerLoc.yy - 1
                                                      direction: MADirectionWest];
    
	MAWallType wallTypeEast = [self.maze wallTypeWithLocationX: cornerLoc.xx
                                                     locationY: cornerLoc.yy
                                                     direction: MADirectionNorth];
    
	MAWallType wallTypeSouth = [self.maze wallTypeWithLocationX: cornerLoc.xx
                                                      locationY: cornerLoc.yy
                                                      direction: MADirectionWest];
    
	MAWallType wallTypeWest = [self.maze wallTypeWithLocationX: cornerLoc.xx - 1
                                                     locationY: cornerLoc.yy
                                                     direction: MADirectionNorth];
	
	MAWallType wallHitNorth = [self.maze hasHitWallWithLocationX: cornerLoc.xx
                                                       locationY: cornerLoc.yy - 1
                                                       direction: MADirectionWest];
    
	MAWallType wallHitEast = [self.maze hasHitWallWithLocationX: cornerLoc.xx
                                                      locationY: cornerLoc.yy
                                                      direction: MADirectionNorth];
    
	MAWallType wallHitSouth = [self.maze hasHitWallWithLocationX: cornerLoc.xx
                                                       locationY: cornerLoc.yy
                                                       direction: MADirectionWest];
    
	MAWallType wallHitWest = [self.maze hasHitWallWithLocationX: cornerLoc.xx - 1
                                                      locationY: cornerLoc.yy
                                                      direction: MADirectionNorth];
	
	if ((wallTypeNorth == MAWallNone || (wallTypeNorth == MAWallInvisible && wallHitNorth == NO)) &&
		(wallTypeEast == MAWallNone || (wallTypeEast == MAWallInvisible && wallHitEast == NO)) &&
		(wallTypeSouth == MAWallNone || (wallTypeSouth == MAWallInvisible && wallHitSouth == NO)) &&
		(wallTypeWest == MAWallNone || (wallTypeWest == MAWallInvisible && wallHitWest == NO)))
	{
		cornerColor = [Styles shared].map.noWallColor;
	}
	else if (wallTypeNorth == MAWallSolid || wallTypeNorth == MAWallFake ||
			 wallTypeEast == MAWallSolid || wallTypeEast == MAWallFake ||
			 wallTypeSouth == MAWallSolid || wallTypeSouth == MAWallFake ||
			 wallTypeWest == MAWallSolid || wallTypeWest == MAWallFake)
	{
		cornerColor = [Styles shared].map.wallColor; 
	}
	else if ((wallTypeNorth == MAWallInvisible && wallHitNorth == YES) ||
			 (wallTypeEast == MAWallInvisible && wallHitEast == YES) ||
			 (wallTypeSouth == MAWallInvisible && wallHitSouth == YES) ||
			 (wallTypeWest == MAWallInvisible && wallHitWest == YES))
	{
		cornerColor = [Styles shared].map.invisibleColor;
	}
	else 
	{
		NSLog(@"Map corner not handled.");
	}
	
	[self addSegmentRect: CGRectMake(cornerStartX, cornerStartY, cornerWidth, cornerHeight) color: cornerColor];
}

- (void)rotateCoordinatesX: (int)x y: (int)y dir: (int)dir rx: (int *)rx ry: (int *)ry rdir: (MADirectionType *)rdir
{
	if (self.currDir == MADirectionNorth)
	{
		*rx = x;
		*ry = y;
		
		*rdir = dir;
	}
	else if (self.currDir == MADirectionEast)
	{
		*rx = -y;
		*ry = x;
		
		*rdir = dir + 1;
	}
	else if (self.currDir == MADirectionSouth)
	{
		*rx = -x;
		*ry = -y;
		
		*rdir = dir + 2;
	}
	else if (self.currDir == MADirectionWest)
	{
		*rx = y;
		*ry = -x;
		
		*rdir = dir + 3;
	}
	
	if (*rdir == 5) *rdir = 1;
	if (*rdir == 6) *rdir = 2;
	if (*rdir == 7) *rdir = 3;
}

- (void)addSegmentRect: (CGRect)rect color: (UIColor *)color
{
	BOOL exists = NO;
	
	for (MapSegment *segment in self.segments)
	{
		if (segment.rect.origin.x == rect.origin.x &&
            segment.rect.origin.y == rect.origin.y &&
            segment.rect.size.width == rect.size.width &&
            segment.rect.size.height == rect.size.height &&
            segment.color == color)
        {
			exists = YES;
        }
	}
	
	if (exists == NO)
	{
		MapSegment *segment = [[MapSegment alloc] init];
		segment.rect = rect;
		segment.color = color;
		[self.segments addObject: segment];
	}
}

- (void)drawRect: (CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	for (MapSegment *segment in self.segments)
	{
		CGContextSetFillColorWithColor(context, segment.color.CGColor);
		CGContextFillRect(context, segment.rect);
	}
}

- (void)clear
{
	self.directionArrowImageView.alpha = 0.0;
	
	[self.segments removeAllObjects];
	
	[self setNeedsDisplay];
}

@end






















