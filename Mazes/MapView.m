//
//  MapView.m
//  iPad_Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"

@implementation MapView

@synthesize mapSegments, directionArrowImageView, currLoc, currDir;

int MapWalls[17][3][3] = 
{
	{{-1, 0, DEF_SOUTH}, {-1, 0, DEF_EAST}, {0, 0, 0}},
	{{0, 0, DEF_SOUTH}, {0, 0, 0}, {0, 0, 0}},
	{{1, 0, DEF_SOUTH}, {1, 0, DEF_WEST}, {0, 0, 0}},
	
	{{0, 0, DEF_WEST}, {0, 0, 0}, {0, 0, 0}},
	{{0, 0, DEF_NORTH}, {0, 0, 0}, {0, 0, 0}},
	{{0, 0, DEF_EAST}, {0, 0, 0}, {0, 0, 0}},
	
	{{-1, 0, DEF_WEST}, {0, 0, DEF_WEST}, {0, 0, 0}},
	{{-1, 0, DEF_NORTH}, {0, 0, DEF_WEST}, {0, 0, 0}},
	{{0, -1, DEF_WEST}, {0, -1, DEF_SOUTH}, {0, 0, 0}},
	{{0, -1, DEF_NORTH}, {0, -1, DEF_SOUTH}, {0, 0, 0}},
	{{0, -1, DEF_EAST}, {0, -1, DEF_SOUTH}, {0, 0, 0}},
	{{1, 0, DEF_NORTH}, {0, 0, DEF_EAST}, {0, 0, 0}},
	{{1, 0, DEF_EAST}, {0, 0, DEF_EAST}, {0, 0, 0}},
	
	{{-1, -1, DEF_WEST}, {-1, -1, DEF_SOUTH}, {0, 0, DEF_WEST}},
	{{-1, -1, DEF_NORTH}, {-1, -1, DEF_EAST}, {0, 0, DEF_NORTH}},
	{{1, -1, DEF_NORTH}, {1, -1, DEF_WEST}, {0, 0, DEF_NORTH}},
	{{1, -1, DEF_EAST}, {1, -1, DEF_SOUTH}, {0, 0, DEF_EAST}},
};

int MapSquares[8][3][3] = 
{
	{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
	{{-1, 0, 0}, {0, 0, DEF_WEST}, {0, 0, 0}},
	{{-1, -1, 0}, {-1, 0, DEF_NORTH}, {0, 0, DEF_WEST}},
	{{-1, -1, 0}, {0, -1, DEF_WEST}, {0, 0, DEF_NORTH}},
	{{0, -1, 0}, {0, 0, DEF_NORTH}, {0, 0, 0}},
	{{1, -1, 0}, {0, -1, DEF_EAST}, {0, 0, DEF_NORTH}},
	{{1, -1, 0}, {1, 0, DEF_NORTH}, {0, 0, DEF_EAST}},
	{{1, 0, 0}, {0, 0, DEF_EAST}, {0, 0, 0}}
};

- (id)initWithCoder: (NSCoder*)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
		// create directional arrow

		UIImage *directionArrowImage = [Utilities createDirectionArrowImageWidth: [Styles shared].map.squareWidth
                                                                          height: [Styles shared].map.squareWidth];
		
		directionArrowImageView = [[UIImageView alloc] initWithImage: directionArrowImage];
		directionArrowImageView.alpha = 0.0;
		
		[self addSubview: directionArrowImageView];
    }
	
	return self;
}

- (void)drawMap
{
	BOOL visible;
	
	float mapXOffset = ([Styles shared].map.length - ([Styles shared].map.squareWidth * [Globals shared].mazeMain.columns + [Styles shared].map.wallWidth * ([Globals shared].mazeMain.columns + 1))) / 2.0; 
	float mapYOffset = ([Styles shared].map.length - ([Styles shared].map.squareWidth * [Globals shared].mazeMain.rows + [Styles shared].map.wallWidth * ([Globals shared].mazeMain.rows + 1))) / 2.0; 
	
	CGPoint mapOffset = CGPointMake(mapXOffset, mapYOffset);
	
	// Map Walls
	
	int wallLocX = 0, wallLocY = 0, wallDir = 0;
	int wallStartX = 0, wallStartY = 0, wallWidth = 0, wallHeight = 0;
	int wallType = 0;
	UIColor *wallColor = nil;
	
	for (int i = 0; i < 17; i = i + 1)
	{
		visible = YES;
		
		for (int j = 1; j < 3; j = j + 1)
		{
			[self rotateMapCoordinatesX: MapWalls[i][j][0] Y: MapWalls[i][j][1] Dir: MapWalls[i][j][2] RX: &wallLocX RY: &wallLocY RDir: &wallDir];
			
			// only consider rows with directions specified
			if (MapWalls[i][j][2] != 0)
			{
				wallType = [[Globals shared].mazeMain.locations getWallTypeLocX: currLoc.x + wallLocX LocY: currLoc.y + wallLocY Direction: wallDir];
				if (wallType == [Constants shared].WallType.Solid || wallType == [Constants shared].WallType.Fake)
                {
					visible = NO;
                }
			}
		}
		
		//NSLog(@"i = %d, visible = %d", i, visible);
		
		if (visible == YES)
		{
			[self rotateMapCoordinatesX: MapWalls[i][0][0] Y: MapWalls[i][0][1] Dir: MapWalls[i][0][2] RX: &wallLocX RY: &wallLocY RDir: &wallDir];
			
			// get drawing location where the wall is North or West
			Location *drawLoc = nil;
			if (wallDir == [Constants shared].Direction.North || wallDir == [Constants shared].Direction.West)
			{
				drawLoc = [[Globals shared].mazeMain.locations getLocationByX: currLoc.x + wallLocX Y: currLoc.y + wallLocY];
			}
			else if (wallDir == [Constants shared].Direction.South)
			{
				drawLoc = [[Globals shared].mazeMain.locations getLocationByX: currLoc.x + wallLocX Y: currLoc.y + wallLocY + 1];
				wallDir = [Constants shared].Direction.North;
			}	
			else if (wallDir == [Constants shared].Direction.East)
			{
				drawLoc = [[Globals shared].mazeMain.locations getLocationByX: currLoc.x + wallLocX + 1 Y: currLoc.y + wallLocY];
				wallDir = [Constants shared].Direction.West;
			}	
			
			// draw wall
			wallType = [[Globals shared].mazeMain.locations getWallTypeLocX: drawLoc.x LocY: drawLoc.y Direction: wallDir];
			
			if (wallDir == [Constants shared].Direction.North)
			{
				wallStartX = mapOffset.x + (drawLoc.x - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
				wallStartY = mapOffset.y + (drawLoc.y - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
				
				wallWidth = [Styles shared].map.squareWidth;
				wallHeight = [Styles shared].map.wallWidth;
			}
			else if (wallDir == [Constants shared].Direction.West)
			{
				wallStartX = mapOffset.x + (drawLoc.x - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
				wallStartY = mapOffset.y + (drawLoc.y - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
				
				wallWidth = [Styles shared].map.wallWidth;
				wallHeight = [Styles shared].map.squareWidth;
			}
			
			if (wallType == [Constants shared].WallType.Solid || wallType == [Constants shared].WallType.Fake)
			{				
				wallColor = [Styles shared].map.wallColor;
			}
			else if ([Constants shared].WallType.Invisible && [[Globals shared].mazeMain.locations hasHitWallAtLocX: drawLoc.x LocY: drawLoc.y Direction: wallDir] == YES) 
			{
				wallColor = [Styles shared].map.invisibleColor;
			}
			else if (wallType == [Constants shared].WallType.None || [Constants shared].WallType.Invisible) 
			{
				wallColor = [Styles shared].map.noWallColor;
			}
			
			[self addMapSegmentRect: CGRectMake(wallStartX, wallStartY, wallWidth, wallHeight) Color: wallColor];
			
			Location *cornerLoc = nil;
			
			// draw corners on either side of wall
			if (wallDir == [Constants shared].Direction.North)
			{
				cornerLoc = drawLoc;
				[self drawMapCornerWithLocation: cornerLoc MapOffset: mapOffset];
				
				cornerLoc = [[Globals shared].mazeMain.locations getLocationByX: drawLoc.x + 1 Y: drawLoc.y];
				[self drawMapCornerWithLocation: cornerLoc MapOffset: mapOffset];				
			}
			else if (wallDir == [Constants shared].Direction.West)
			{
				cornerLoc = drawLoc;
				[self drawMapCornerWithLocation: cornerLoc MapOffset: mapOffset];
				
				cornerLoc = [[Globals shared].mazeMain.locations getLocationByX: drawLoc.x Y: drawLoc.y + 1];
				[self drawMapCornerWithLocation: cornerLoc MapOffset: mapOffset];				
			}
		}
	}	
	
	// Map Squares
	
	int squareX = 0, squareY = 0;
	int squareStartX = 0, squareStartY = 0, squareWidth = 0, squareHeight = 0;
	UIColor *squareColor = nil;
	
	for (int i = 0; i < 8; i = i + 1)
	{
		visible = YES;
		
		for (int j = 1; j < 3; j = j + 1)
		{
			[self rotateMapCoordinatesX: MapSquares[i][j][0] Y: MapSquares[i][j][1] Dir: MapSquares[i][j][2] RX: &squareX RY: &squareY RDir: &wallDir];
			
			if (MapSquares[i][j][2] != 0)
			{
				wallType = [[Globals shared].mazeMain.locations getWallTypeLocX: currLoc.x + squareX LocY: currLoc.y + squareY Direction: wallDir]; 
				if (wallType == [Constants shared].WallType.Solid || wallType == [Constants shared].WallType.Fake)
                {
					visible = NO;
                }
			}
		}
		
		if (visible == YES)
		{
			[self rotateMapCoordinatesX: MapSquares[i][0][0] Y: MapSquares[i][0][1] Dir: MapSquares[i][0][2] RX: &squareX RY: &squareY RDir: &wallDir];
			
			Location *drawLoc = [[Globals shared].mazeMain.locations getLocationByX: currLoc.x + squareX Y: currLoc.y + squareY];
			
			squareStartX = mapOffset.x + (drawLoc.x - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
			squareStartY = mapOffset.y + (drawLoc.y - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
			
			squareWidth = [Styles shared].map.squareWidth;
			squareHeight = [Styles shared].map.squareWidth;
			
			if (drawLoc.type == [Constants shared].LocationType.Start)
            {
				squareColor = [Styles shared].map.startColor;
            }
			else if (drawLoc.type == [Constants shared].LocationType.End)
            {
				squareColor = [Styles shared].map.endColor;
            }
			else if (drawLoc.type == [Constants shared].LocationType.StartOver && drawLoc.visited == YES)
            {
				squareColor = [Styles shared].map.startOverColor;
            }
			else if (drawLoc.type == [Constants shared].LocationType.Teleportation && drawLoc.visited == YES)
            {
				squareColor = [Styles shared].map.teleportationColor;
            }
			else
            {
				squareColor = [Styles shared].map.doNothingColor;
            }
			
			[self addMapSegmentRect: CGRectMake(squareStartX, squareStartY, squareWidth, squareHeight) Color: squareColor];
		}
	}
	
	// Draw map
	[self setNeedsDisplay];
	
	// Draw directional arrow
	if (directionArrowImageView.alpha == 0.0)
		directionArrowImageView.alpha = 1.0;
	
	float arrowX = mapOffset.x + (currLoc.x - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
	float arrowY = mapOffset.y + (currLoc.y - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth) + [Styles shared].map.wallWidth;
	
	directionArrowImageView.frame = CGRectMake(arrowX, arrowY, [Styles shared].map.squareWidth, [Styles shared].map.squareWidth);
	
	float theta = 0.0;
	if (currDir == [Constants shared].Direction.North) theta = 0.0;
	if (currDir == [Constants shared].Direction.East) theta = 90.0;
	if (currDir == [Constants shared].Direction.South) theta = 180.0;
	if (currDir == [Constants shared].Direction.West) theta = 270.0;
	[Utilities rotateImageView: directionArrowImageView angleDegrees: theta];
}

// corner is at top-left of location
- (void)drawMapCornerWithLocation: (Location *)cornerLoc MapOffset: (CGPoint)mapOffset
{
	int cornerStartX = mapOffset.x + (cornerLoc.x - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
	int cornerStartY = mapOffset.y + (cornerLoc.y - 1) * ([Styles shared].map.squareWidth + [Styles shared].map.wallWidth);
	
	int cornerWidth = [Styles shared].map.wallWidth;
	int cornerHeight = [Styles shared].map.wallWidth;
	
	UIColor *cornerColor = nil;
	
	// relative to corner
	int wallTypeNorth = [[Globals shared].mazeMain.locations getWallTypeLocX: cornerLoc.x LocY: cornerLoc.y - 1 Direction: [Constants shared].Direction.West];
	int wallTypeEast = [[Globals shared].mazeMain.locations getWallTypeLocX: cornerLoc.x LocY: cornerLoc.y Direction: [Constants shared].Direction.North];
	int wallTypeSouth = [[Globals shared].mazeMain.locations getWallTypeLocX: cornerLoc.x LocY: cornerLoc.y Direction: [Constants shared].Direction.West];
	int wallTypeWest = [[Globals shared].mazeMain.locations getWallTypeLocX: cornerLoc.x - 1 LocY: cornerLoc.y Direction: [Constants shared].Direction.North];
	
	int wallHitNorth = [[Globals shared].mazeMain.locations hasHitWallAtLocX: cornerLoc.x LocY: cornerLoc.y - 1 Direction: [Constants shared].Direction.West];
	int wallHitEast = [[Globals shared].mazeMain.locations hasHitWallAtLocX: cornerLoc.x LocY: cornerLoc.y Direction: [Constants shared].Direction.North];
	int wallHitSouth = [[Globals shared].mazeMain.locations hasHitWallAtLocX: cornerLoc.x LocY: cornerLoc.y Direction: [Constants shared].Direction.West];
	int wallHitWest = [[Globals shared].mazeMain.locations hasHitWallAtLocX: cornerLoc.x - 1 LocY: cornerLoc.y Direction: [Constants shared].Direction.North];
	
	if ((wallTypeNorth == [Constants shared].WallType.None || (wallTypeNorth == [Constants shared].WallType.Invisible && wallHitNorth == NO)) &&
		(wallTypeEast == [Constants shared].WallType.None || (wallTypeEast == [Constants shared].WallType.Invisible && wallHitEast == NO)) &&
		(wallTypeSouth == [Constants shared].WallType.None || (wallTypeSouth == [Constants shared].WallType.Invisible && wallHitSouth == NO)) &&
		(wallTypeWest == [Constants shared].WallType.None || (wallTypeWest == [Constants shared].WallType.Invisible && wallHitWest == NO)))
	{
		cornerColor = [Styles shared].map.noWallColor;
	}
	else if (wallTypeNorth == [Constants shared].WallType.Solid || wallTypeNorth == [Constants shared].WallType.Fake ||
			 wallTypeEast == [Constants shared].WallType.Solid || wallTypeEast == [Constants shared].WallType.Fake ||
			 wallTypeSouth == [Constants shared].WallType.Solid || wallTypeSouth == [Constants shared].WallType.Fake ||
			 wallTypeWest == [Constants shared].WallType.Solid || wallTypeWest == [Constants shared].WallType.Fake)
	{
		cornerColor = [Styles shared].map.wallColor;
	}
	else if ((wallTypeNorth == [Constants shared].WallType.Invisible && wallHitNorth == YES) ||
			 (wallTypeEast == [Constants shared].WallType.Invisible && wallHitEast == YES) ||
			 (wallTypeSouth == [Constants shared].WallType.Invisible && wallHitSouth == YES) ||
			 (wallTypeWest == [Constants shared].WallType.Invisible && wallHitWest == YES))
	{
		cornerColor = [Styles shared].map.invisibleColor;
	}
	else 
	{
		NSLog(@"Map corner not handled.");
	}
	
	[self addMapSegmentRect: CGRectMake(cornerStartX, cornerStartY, cornerWidth, cornerHeight) Color: cornerColor];
}

- (void)rotateMapCoordinatesX: (int)x Y: (int)y Dir: (int)dir RX: (int *)rx RY: (int *)ry RDir: (int *)rdir
{
	if (currDir == [Constants shared].Direction.North)
	{
		*rx = x;
		*ry = y;
		
		*rdir = dir;
	}
	else if (currDir == [Constants shared].Direction.East)
	{
		*rx = -y;
		*ry = x;
		
		*rdir = dir + 1;
	}
	else if (currDir == [Constants shared].Direction.South)
	{
		*rx = -x;
		*ry = -y;
		
		*rdir = dir + 2;
	}
	else if (currDir == [Constants shared].Direction.West)
	{
		*rx = y;
		*ry = -x;
		
		*rdir = dir + 3;
	}
	
	if (*rdir == 5) *rdir = 1;
	if (*rdir == 6) *rdir = 2;
	if (*rdir == 7) *rdir = 3;
}

- (void)addMapSegmentRect: (CGRect)rect Color: (UIColor *)color
{
	BOOL segmentExists = NO;
	
	for (MapSegment *seg in mapSegments)
	{
		if (seg.rect.origin.x == rect.origin.x && seg.rect.origin.y == rect.origin.y && seg.rect.size.width == rect.size.width && seg.rect.size.height == rect.size.height && seg.color == color)
			segmentExists = YES;
	}
	
	if (segmentExists == NO)
	{
		MapSegment *seg = [[MapSegment alloc] init];
		seg.rect = rect;
		seg.color = color;
		[mapSegments addObject: seg];
	}
}

- (void)clearMap
{
	directionArrowImageView.alpha = 0.0;
	
	[mapSegments removeAllObjects];
	
	[self setNeedsDisplay];
}

- (void)drawRect: (CGRect)rect 
{	
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	for (MapSegment *seg in mapSegments)
	{
		CGContextSetFillColorWithColor(context, seg.color.CGColor);
		CGContextFillRect(context, seg.rect);
	}
}

@end
