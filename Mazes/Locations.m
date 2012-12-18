//
//  Locations.m
//  iPad_Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Locations.h"

@implementation Locations

@synthesize array;

- (id)init
{
	self = [super init];
	
    if (self)
	{
		array = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)populateWithRows: (int)rows Columns: (int)columns
{
	for (int LocX = 1; LocX <= columns + 1; LocX = LocX + 1)
	{
		for (int LocY = 1; LocY <= rows + 1; LocY = LocY + 1)
		{
			Location *location = [[Location alloc] init];
			location.X = LocX;
			location.Y = LocY;
			
			[array addObject: location];
		}
	}
}

/*
- (void)populateWithXML: (xmlDocPtr)doc
{
	xmlNodePtr node = [XML getNodesFromDoc: doc XPath: "/Response/Locations/Location"];
	
	xmlNodePtr nodeCurr;
	for (nodeCurr = node; nodeCurr; nodeCurr = nodeCurr->next)
	{
		Location *location = [[Location alloc] init];
		
		location.mazeId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "MazeId"] intValue];
		location.x = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "X"] intValue];
		location.y = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Y"] intValue];
		location.direction = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Direction"] intValue];
		location.wallNorth = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "WallNorth"] intValue];
		location.wallWest = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "WallWest"] intValue];
		location.type = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Type"] intValue];
		location.message = [XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "Message"];
		location.teleportId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "TeleportId"] intValue];
		location.teleportX = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "TeleportX"] intValue];
		location.teleportY = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "TeleportY"] intValue];
		location.wallNorthTextureId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "WallNorthTextureId"] intValue];
		location.wallWestTextureId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "WallWestTextureId"] intValue];
		location.floorTextureId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "FloorTextureId"] intValue];
		location.ceilingTextureId = [[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "CeilingTextureId"] intValue];
		
		[array addObject: location];
	}
	
	xmlFreeNodeList(node);
}
*/

- (void)reset
{
	[array removeAllObjects];
}

- (void)UpdateMazeId: (int)mazeId
{
	for (Location *loc in array)
	{
		loc.MazeId = mazeId;
	}	
}

- (Location *)getLocationByX: (int)x Y: (int)y
{
	Location *location = nil;
	
	for (Location *loc in array)
	{
		if (loc.x == x && loc.y == y)
        {
			location = loc;
        }
	}
	
	return location;
}

- (Location *)getLocationByType: (int)type
{
	Location *location = nil;
	
	for (Location *loc in array)
	{
		if (loc.type == type)
        {
			location = loc;
        }
	}

	return location;
}

- (BOOL)IsSurroundedByWallsLocation: (Location *)location
{
	BOOL surrounded = NO;
	
	int wallTypeNorth = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.North];
	int wallTypeEast = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.East];
	int wallTypeSouth = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.South];
	int wallTypeWest = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.West];

	if ((wallTypeNorth == [Constants shared].WallType.Solid || wallTypeNorth == [Constants shared].WallType.Invisible) &&
		(wallTypeEast == [Constants shared].WallType.Solid || wallTypeEast == [Constants shared].WallType.Invisible) &&
		(wallTypeSouth == [Constants shared].WallType.Solid || wallTypeSouth == [Constants shared].WallType.Invisible) &&
		(wallTypeWest == [Constants shared].WallType.Solid || wallTypeWest == [Constants shared].WallType.Invisible))
	{
		surrounded = YES;
	}
		
	return surrounded;
}

- (int)getWallTypeLocX: (int)locX LocY: (int)locY Direction: (int)direction
{
	int type = 0;
	Location *location;
	
	if (direction == [Constants shared].Direction.North)
	{
		location = [self getLocationByX: locX Y: locY];

		type = location.wallNorth;
	}
	else if (direction == [Constants shared].Direction.West)
	{
		location = [self getLocationByX: locX Y: locY];
		
		type = location.wallWest;
	}
	else if (direction == [Constants shared].Direction.South)
	{
		location = [self getLocationByX: locX Y: locY + 1];
		
		type = location.wallNorth;
	}
	else if (direction == [Constants shared].Direction.East)
	{
		location = [self getLocationByX: locX + 1 Y: locY];
		
		type = location.wallWest;
	}
	
	return type;
}

- (BOOL)hasHitWallAtLocX: (int)locX LocY: (int)locY Direction: (int)direction
{
	Location *location;
	BOOL hitWall = NO;
	
	if (direction == [Constants shared].Direction.North)
	{
		location = [self getLocationByX: locX Y: locY];
		
		hitWall = location.wallNorthHit;
	}
	else if (direction == [Constants shared].Direction.West)
	{
		location = [self getLocationByX: locX Y: locY];
		
		hitWall = location.wallWestHit;
	}
	else if (direction == [Constants shared].Direction.South)
	{
		location = [self getLocationByX: locX Y: locY + 1];
		
		hitWall = location.wallNorthHit;
	}
	else if (direction == [Constants shared].Direction.East)
	{
		location = [self getLocationByX: locX + 1 Y: locY];
		
		hitWall = location.wallWestHit;
	}
	
	return hitWall;
}

- (BOOL)IsInnerWallWithLocation: (Location *)location Rows: (int)rows Columns: (int)columns WallDir: (int)wallDir
{
	BOOL val;
	
	if ((location.x == 1 && location.y >= 2 && location.y <= rows && wallDir == [Constants shared].Direction.North) ||
		(location.y == 1 && location.x >= 2 && location.x <= columns && wallDir == [Constants shared].Direction.West) ||
		(location.x >= 2 && location.x <= columns && location.y >= 2 && location.y <= rows))
		val = YES;
	else 
		val = NO;

	return val;
}

- (void)setWallTypeLocX: (int)locX LocY: (int)locY Direction: (int)direction Type: (int)type
{
	Location *location;

	if (direction == [Constants shared].Direction.North)
	{
		location = [self getLocationByX: locX Y: locY];
		
		location.WallNorth = type;
	}
	else if (direction == [Constants shared].Direction.West)
	{
		location = [self getLocationByX: locX Y: locY];
		
		location.WallWest = type;
	}
	else if (direction == [Constants shared].Direction.South)
	{
		location = [self getLocationByX: locX Y: locY + 1];
		
		location.WallNorth = type;
	}
	else if (direction == [Constants shared].Direction.East)
	{
		location = [self getLocationByX: locX + 1 Y: locY];
		
		location.WallWest = type;
	}
}

- (void)setWallHitLocX: (int)locX LocY: (int)locY Direction: (int)direction
{
	Location *location;
	
	if (direction == [Constants shared].Direction.North)
	{
		location = [self getLocationByX: locX Y: locY];
		
		location.WallNorthHit = YES;
	}
	else if (direction == [Constants shared].Direction.West)
	{
		location = [self getLocationByX: locX Y: locY];
		
		location.WallWestHit = YES;
	}
	else if (direction == [Constants shared].Direction.South)
	{
		location = [self getLocationByX: locX Y: locY + 1];
		
		location.WallNorthHit = YES;
	}
	else if (direction == [Constants shared].Direction.East)
	{
		location = [self getLocationByX: locX + 1 Y: locY];
		
		location.WallWestHit = YES;
	}
}

- (void)drawGridWithCurrLoc: (Location *)currLoc CurrWallLoc: (Location *)currWallLoc CurrWallDir: (int)currWallDir Rows: (int)rows Columns: (int)columns
{
	CGRect segmentRect;
	
	CGContextRef context = UIGraphicsGetCurrentContext();	

	for (Location *location in array)
	{
		if (location.x <= columns && location.y <= rows)
		{
			segmentRect = [self getSegmentRectFromLocation: location SegmentType: [Constants shared].MazeObject.Location];
			
			if (location.type == [Constants shared].LocationType.Start)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startColor.CGColor);
			}
			else if (location.type == [Constants shared].LocationType.End)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.endColor.CGColor);
			}
			else if (location.type == [Constants shared].LocationType.StartOver)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startOverColor.CGColor);
			}
			else if (location.type == [Constants shared].LocationType.Teleportation)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.teleportationColor.CGColor);
			}
			else if ([location.message isEqualToString: @""] == NO)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.messageColor.CGColor);
			}
			else
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.doNothingColor.CGColor);
			}
			
			CGContextFillRect(context, segmentRect);
			
			if (location.type == [Constants shared].LocationType.Start || location.type == [Constants shared].LocationType.Teleportation)
			{
				[Utilities drawArrowInRect: segmentRect angleDegrees: location.direction scale: 0.8];
				
				if (location.type == [Constants shared].LocationType.Teleportation)
				{
					CGContextSetFillColorWithColor(context, [Styles shared].grid.teleportIdColor.CGColor);
				
					NSString *num = [NSString stringWithFormat: @"%d", location.teleportId];
				
					[num drawInRect: segmentRect
                           withFont: [UIFont systemFontOfSize: [Styles shared].grid.teleportFontSize]
                      lineBreakMode: NSLineBreakByClipping
                          alignment: NSTextAlignmentCenter];
				}
			}				
			
			if (location.floorTextureId != 0 || location.ceilingTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}	
				
			if (currLoc != nil)
			{
				if (location.x == currLoc.x && location.y == currLoc.y)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.locationHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall North
		
		if (location.x <= columns)
		{
			segmentRect = [self getSegmentRectFromLocation: location SegmentType: [Constants shared].MazeObject.WallNorth];
						
			// outer wall
			if (location.y == 1 || location.y == rows + 1)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
				CGContextFillRect(context, segmentRect);
			}
			else
			{
				int wallType = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.North];
				
				if (wallType == [Constants shared].WallType.None)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Solid)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Invisible)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Fake)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.fakeColor.CGColor);
                }
									
				CGContextFillRect(context, segmentRect);
			}
			
			if (location.wallNorthTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}	
						
			if (currWallLoc != nil)
			{
				if (location.x == currWallLoc.x && location.y == currWallLoc.y && currWallDir == [Constants shared].Direction.North)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall West
		
		if (location.y <= rows)
		{
			segmentRect = [self getSegmentRectFromLocation: location SegmentType: [Constants shared].MazeObject.WallWest];

			// outer wall
			if (location.x == 1 || location.x == columns + 1)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
				CGContextFillRect(context, segmentRect);
			}
			else
			{
				int wallType = [self getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.West];
				
				if (wallType == [Constants shared].WallType.None)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Solid)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Invisible)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                }
				else if (wallType == [Constants shared].WallType.Fake)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.fakeColor.CGColor);
                }
				
				CGContextFillRect(context, segmentRect);
			}

			if (location.wallNorthTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}	
			
			if (currWallLoc != nil)
			{
				if (location.x == currWallLoc.x && location.y == currWallLoc.y && currWallDir == [Constants shared].Direction.West)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Corner

		segmentRect = [self getSegmentRectFromLocation: location SegmentType: [Constants shared].MazeObject.Corner];

		if (location.y > 1 && location.y <= rows && location.x > 1 && location.x <= columns)
		{
			CGContextSetFillColorWithColor(context, [Styles shared].grid.cornerColor.CGColor);
			CGContextFillRect(context, segmentRect);
		}	
		else
		{
			CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
			CGContextFillRect(context, segmentRect);
		}
	}
}

- (Location *)getGridLocationFromTouchPoint: (CGPoint)touchPoint Rows: (int)rows Columns: (int)columns
{
	Location *loc = nil;
	
	CGRect segmentRect = CGRectZero, touchRect = CGRectZero;
	
	for (Location *location in array)
	{	
		segmentRect = [self getSegmentRectFromLocation: location SegmentType: [Constants shared].MazeObject.Location];

		touchRect = CGRectMake(segmentRect.origin.x - [Styles shared].grid.segmentLengthShort / 2.0, segmentRect.origin.y - [Styles shared].grid.segmentLengthShort / 2.0, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		
		if (CGRectContainsPoint(touchRect, touchPoint) && location.x <= columns && location.y <= rows)
		{
			loc = location;
			break;
		}
	}

	return loc;
}
	
- (Location *)getGridWallLocationSegType: (int *)segType FromTouchPoint: (CGPoint)touchPoint Rows: (int)rows Columns: (int)columns 
{
	CGRect segmentRect = CGRectZero;	
	CGPoint segmentOrigin = CGPointZero;
	
	float tx = 0.0, ty = 0.0;
	float b = ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort) / 2.0;
	
	for (Location *location in array)
	{	
		for (int i = 1; i <= 2; i = i + 1)
		{
			if (i == 1) 
			{
				*segType = [Constants shared].MazeObject.WallNorth;				
			}
			else if (i == 2)
			{
				*segType = [Constants shared].MazeObject.WallWest;
			}
			
			segmentRect = [self getSegmentRectFromLocation: location SegmentType: *segType];
			
			segmentOrigin.x = segmentRect.origin.x + segmentRect.size.width / 2.0;
			segmentOrigin.y = segmentRect.origin.y + segmentRect.size.height / 2.0;

			tx = touchPoint.x - segmentOrigin.x;
			ty = touchPoint.y - segmentOrigin.y;
			
			BOOL found = NO;
			if (tx >= -b && tx <= 0)
			{
				if (ty >= -tx - b && ty <= tx + b)
				{
					found = YES;
				}
			}
			else if (tx >= 0 && tx <= b)
			{
				if (ty >= tx - b && ty <= -tx + b)
				{
					found = YES;
				}
			}
			
			if (found == YES)
			{
				if ((location.x <= columns && location.y <= rows) ||
					(location.x == columns + 1 && *segType == [Constants shared].MazeObject.WallWest && location.y <= rows) ||
					(location.y == rows + 1 && *segType == [Constants shared].MazeObject.WallNorth && location.x <= columns))
				{
					return location;
				}
			}
		}
	}
		
	return nil;
}

- (CGRect)getSegmentRectFromLocation: (Location *)location SegmentType: (int)segmentType
{
	float segmentX = 0.0, segmentY = 0.0, width = 0.0, height = 0.0;
	
	if (segmentType == [Constants shared].MazeObject.Location)
	{
		segmentX = [Styles shared].grid.segmentLengthShort + (location.x - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		segmentY = [Styles shared].grid.segmentLengthShort + (location.y - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		
		width = [Styles shared].grid.segmentLengthLong;
		height = [Styles shared].grid.segmentLengthLong; 
	}
	else if (segmentType == [Constants shared].MazeObject.WallNorth)
	{
		segmentX = [Styles shared].grid.segmentLengthShort + (location.x - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
		segmentY = (location.y - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
		
		width = [Styles shared].grid.segmentLengthLong;
		height = [Styles shared].grid.segmentLengthShort; 
	}
	else if (segmentType == [Constants shared].MazeObject.WallWest)
	{
		segmentX = (location.x - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
		segmentY = [Styles shared].grid.segmentLengthShort + (location.y - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);	
		
		width = [Styles shared].grid.segmentLengthShort;
		height = [Styles shared].grid.segmentLengthLong; 
	}
	else if (segmentType == [Constants shared].MazeObject.Corner)
	{
		segmentX = (location.x - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		segmentY = (location.y - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);	
		
		width = [Styles shared].grid.segmentLengthShort;
		height = [Styles shared].grid.segmentLengthShort; 
	}
	
	return CGRectMake(segmentX, segmentY, width, height);
}

/*
- (xmlNodePtr)CreateLocationsXMLWithDoc: (xmlDocPtr)doc
{
	xmlNodePtr locationsNode = [XML CreateNodeDoc: doc NodeName: @"Locations"];
	
	for (Location *location in array)
	{
		xmlNodePtr locationNode = [XML CreateNodeDoc: doc NodeName: @"Location"];
	
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", location.mazeId]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"X" NodeValue: [NSString stringWithFormat: @"%d", location.x]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"Y" NodeValue: [NSString stringWithFormat: @"%d", location.y]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"Direction" NodeValue: [NSString stringWithFormat: @"%d", location.direction]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"WallNorth" NodeValue: [NSString stringWithFormat: @"%d", location.wallNorth]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"WallWest" NodeValue: [NSString stringWithFormat: @"%d", location.wallWest]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"Type" NodeValue: [NSString stringWithFormat: @"%d", location.type]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"Message" NodeValue: location.message];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"TeleportId" NodeValue: [NSString stringWithFormat: @"%d", location.teleportId]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"TeleportX" NodeValue: [NSString stringWithFormat: @"%d", location.teleportX]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"TeleportY" NodeValue: [NSString stringWithFormat: @"%d", location.teleportY]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"WallNorthTextureId" NodeValue: [NSString stringWithFormat: @"%d", location.wallNorthTextureId]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"WallWestTextureId" NodeValue: [NSString stringWithFormat: @"%d", location.wallWestTextureId]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"FloorTextureId" NodeValue: [NSString stringWithFormat: @"%d", location.floorTextureId]];
		[XML addNodeDoc: doc Parent: locationNode NodeName: @"CeilingTextureId" NodeValue: [NSString stringWithFormat: @"%d", location.ceilingTextureId]];
		
		[XML AddChildNode: locationNode ToParent: locationsNode];
	}

	return locationsNode;
}
*/

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", array];
}

@end













