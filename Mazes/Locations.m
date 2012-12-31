//
//  Locations.m
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "Locations.h"

@implementation Locations

- (id)init
{
	self = [super init];
	
    if (self)
	{
        self->list = [[NSMutableArray alloc] init];
    }
	
	return self;
}

- (void)populateWithRows: (int)rows columns: (int)columns
{
	for (int LocX = 1; LocX <= columns + 1; LocX = LocX + 1)
	{
		for (int LocY = 1; LocY <= rows + 1; LocY = LocY + 1)
		{
			Location *location = [[Location alloc] init];
			location.X = LocX;
			location.Y = LocY;
			
			[self->list addObject: location];
		}
	}
}

- (void)populateWithArray: (NSArray *)locations
{
    self->list = [NSMutableArray arrayWithArray: locations];
}

- (NSArray *)all
{
    return self->list;
}

- (void)removeAll
{
	[self->list removeAllObjects];
}

- (void)updateMazeId: (int)mazeId
{
	for (Location *loc in self->list)
	{
		loc.MazeId = mazeId;
	}	
}

- (Location *)getLocationByX: (int)x y: (int)y
{
	Location *location = nil;
	
	for (Location *loc in self->list)
	{
		if (loc.x == x && loc.y == y)
        {
			location = loc;
        }
	}
	
	return location;
}

- (Location *)getLocationByAction: (MALocationActionType)action
{
	Location *location = nil;
	
	for (Location *loc in self->list)
	{
		if (loc.action == action)
        {
			location = loc;
        }
	}

	return location;
}

- (BOOL)isSurroundedByWallsLocation: (Location *)location
{
	BOOL surrounded = NO;
	
	MAWallType wallTypeNorth = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionNorth];
	MAWallType wallTypeEast = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionEast];
	MAWallType wallTypeSouth = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionSouth];
	MAWallType wallTypeWest = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionWest];

	if ((wallTypeNorth == MAWallSolid || wallTypeNorth == MAWallInvisible) &&
		(wallTypeEast == MAWallSolid || wallTypeEast == MAWallInvisible) &&
		(wallTypeSouth == MAWallSolid || wallTypeSouth == MAWallInvisible) &&
		(wallTypeWest == MAWallSolid || wallTypeWest == MAWallInvisible))
	{
		surrounded = YES;
	}
		
	return surrounded;
}

- (MAWallType)getWallTypeLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction
{
	int type = 0;
	Location *location;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self getLocationByX: locX y: locY];
            type = location.wallNorth;
            break;
            
        case MADirectionWest:
            location = [self getLocationByX: locX y: locY];
            type = location.wallWest;
            break;
            
        case MADirectionSouth:
            location = [self getLocationByX: locX y: locY + 1];
            type = location.wallNorth;
            break;
            
        case MADirectionEast:
            location = [self getLocationByX: locX + 1 y: locY];
            type = location.wallWest;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
    
	return type;
}

- (BOOL)hasHitWallAtLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction
{
	Location *location;
	BOOL hitWall = NO;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self getLocationByX: locX y: locY];
            hitWall = location.wallNorthHit;
            break;
            
        case MADirectionWest:
            location = [self getLocationByX: locX y: locY];
            hitWall = location.wallWestHit;
            break;
            
        case MADirectionSouth:
            location = [self getLocationByX: locX y: locY + 1];
            hitWall = location.wallNorthHit;
            break;
            
        case MADirectionEast:
            location = [self getLocationByX: locX + 1 y: locY];
            hitWall = location.wallWestHit;
            break;

        default:
            [Utilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
    
	
	return hitWall;
}

- (BOOL)isInnerWallWithLocation: (Location *)location rows: (int)rows columns: (int)columns wallDir: (MADirectionType)wallDir
{
	BOOL val;
	
	if ((location.x == 1 && location.y >= 2 && location.y <= rows && wallDir == MADirectionNorth) ||
		(location.y == 1 && location.x >= 2 && location.x <= columns && wallDir == MADirectionWest) ||
		(location.x >= 2 && location.x <= columns && location.y >= 2 && location.y <= rows))
    {
		val = YES;
    }
	else
    {
		val = NO;
    }

	return val;
}

- (void)setWallTypeLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction type: (MAWallType)type
{
	Location *location;

    switch (direction)
    {
        case MADirectionNorth:
            location = [self getLocationByX: locX y: locY];
            location.WallNorth = type;
            break;
            
        case MADirectionWest:
            location = [self getLocationByX: locX y: locY];
            location.WallWest = type;
            break;
            
        case MADirectionSouth:
            location = [self getLocationByX: locX y: locY + 1];
            location.WallNorth = type;
            break;
            
        case MADirectionEast:
            location = [self getLocationByX: locX + 1 y: locY];
            location.WallWest = type;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
}

- (void)setWallHitLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction
{
	Location *location;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self getLocationByX: locX y: locY];
            location.WallNorthHit = YES;
            break;
            
        case MADirectionWest:
            location = [self getLocationByX: locX y: locY];
            location.WallWestHit = YES;
            break;
            
        case MADirectionSouth:
            location = [self getLocationByX: locX y: locY + 1];
            location.WallNorthHit = YES;
            break;
            
        case MADirectionEast:
            location = [self getLocationByX: locX + 1 y: locY];
            location.WallWestHit = YES;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
}

- (void)drawGridWithCurrLoc: (Location *)currLoc currWallLoc: (Location *)currWallLoc currWallDir: (MADirectionType)currWallDir rows: (int)rows columns: (int)columns
{
	CGRect segmentRect;
	
	CGContextRef context = UIGraphicsGetCurrentContext();	

	for (Location *location in self->list)
	{
		if (location.x <= columns && location.y <= rows)
		{
			segmentRect = [self getSegmentRectFromLocation: location segmentType: MAMazeObjectLocation];
			
			if (location.action == MALocationActionStart)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startColor.CGColor);
			}
			else if (location.action == MALocationActionEnd)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.endColor.CGColor);
			}
			else if (location.action == MALocationActionStartOver)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startOverColor.CGColor);
			}
			else if (location.action == MALocationActionTeleport)
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
			
			if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
			{
				[Utilities drawArrowInRect: segmentRect angleDegrees: location.direction scale: 0.8];
				
				if (location.action == MALocationActionTeleport)
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
			segmentRect = [self getSegmentRectFromLocation: location segmentType: MAMazeObjectWallNorth];
						
			// outer wall
			if (location.y == 1 || location.y == rows + 1)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
				CGContextFillRect(context, segmentRect);
			}
			else
			{
				MAWallType wallType = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionNorth];
				
				if (wallType == MAWallNone)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                }
				else if (wallType == MAWallSolid)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);
                }
				else if (wallType == MAWallInvisible)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                }
				else if (wallType == MAWallFake)
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
				if (location.x == currWallLoc.x && location.y == currWallLoc.y && currWallDir == MADirectionNorth)
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
			segmentRect = [self getSegmentRectFromLocation: location segmentType: MAMazeObjectWallWest];

			// outer wall
			if (location.x == 1 || location.x == columns + 1)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
				CGContextFillRect(context, segmentRect);
			}
			else
			{
				MAWallType wallType = [self getWallTypeLocX: location.x locY: location.y direction: MADirectionWest];
				
				if (wallType == MAWallNone)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                }
				else if (wallType == MAWallSolid)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);
                }
				else if (wallType == MAWallInvisible)
                {
					CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                }
				else if (wallType == MAWallFake)
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
				if (location.x == currWallLoc.x && location.y == currWallLoc.y && currWallDir == MADirectionWest)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Corner

		segmentRect = [self getSegmentRectFromLocation: location segmentType: MAMazeObjectCorner];

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

- (Location *)getGridLocationFromTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns
{
	Location *loc = nil;
	
	CGRect segmentRect = CGRectZero, touchRect = CGRectZero;
	
	for (Location *location in self->list)
	{	
		segmentRect = [self getSegmentRectFromLocation: location segmentType: MAMazeObjectLocation];

		touchRect = CGRectMake(segmentRect.origin.x - [Styles shared].grid.segmentLengthShort / 2.0, segmentRect.origin.y - [Styles shared].grid.segmentLengthShort / 2.0, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		
		if (CGRectContainsPoint(touchRect, touchPoint) && location.x <= columns && location.y <= rows)
		{
			loc = location;
			break;
		}
	}

	return loc;
}
	
- (Location *)getGridWallLocationSegType: (MAMazeObjectType *)segType fromTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns
{
	CGRect segmentRect = CGRectZero;	
	CGPoint segmentOrigin = CGPointZero;
	
	float tx = 0.0, ty = 0.0;
	float b = ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort) / 2.0;
	
	for (Location *location in self->list)
	{	
		for (int i = 1; i <= 2; i = i + 1)
		{
			if (i == 1) 
			{
				*segType = MAMazeObjectWallNorth;
			}
			else if (i == 2)
			{
				*segType = MAMazeObjectWallWest;
			}
			
			segmentRect = [self getSegmentRectFromLocation: location segmentType: *segType];
			
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
					(location.x == columns + 1 && *segType == MAMazeObjectWallWest && location.y <= rows) ||
					(location.y == rows + 1 && *segType == MAMazeObjectWallNorth && location.x <= columns))
				{
					return location;
				}
			}
		}
	}
		
	return nil;
}

- (CGRect)getSegmentRectFromLocation: (Location *)location segmentType: (MAMazeObjectType)segmentType
{
	float segmentX = 0.0, segmentY = 0.0, width = 0.0, height = 0.0;
	
    switch (segmentType)
    {
        case MAMazeObjectLocation:
            segmentX = [Styles shared].grid.segmentLengthShort + (location.x - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            segmentY = [Styles shared].grid.segmentLengthShort + (location.y - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            
            width = [Styles shared].grid.segmentLengthLong;
            height = [Styles shared].grid.segmentLengthLong;
        
            break;
            
    case MAMazeObjectWallNorth:
            segmentX = [Styles shared].grid.segmentLengthShort + (location.x - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            segmentY = (location.y - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            
            width = [Styles shared].grid.segmentLengthLong;
            height = [Styles shared].grid.segmentLengthShort;
        
            break;
        
    case MAMazeObjectWallWest:
            segmentX = (location.x - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            segmentY = [Styles shared].grid.segmentLengthShort + (location.y - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            
            width = [Styles shared].grid.segmentLengthShort;
            height = [Styles shared].grid.segmentLengthLong;
        
            break;
        
    case MAMazeObjectCorner:
        
            segmentX = (location.x - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            segmentY = (location.y - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            
            width = [Styles shared].grid.segmentLengthShort;
            height = [Styles shared].grid.segmentLengthShort;
        
            break;
        
        default:
            [Utilities logWithClass: [self class] format: @"segmentType set to an illegal value: %d", segmentType];
            break;
    }
    
	return CGRectMake(segmentX, segmentY, width, height);
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", self->list];
}

@end













