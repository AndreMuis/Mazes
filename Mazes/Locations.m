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
        _list = nil;
    }
	
	return self;
}

- (void)populateWithRows: (int)rows columns: (int)columns
{
    self.list = [[NSMutableArray alloc] init];

	for (int LocX = 1; LocX <= columns + 1; LocX = LocX + 1)
	{
		for (int LocY = 1; LocY <= rows + 1; LocY = LocY + 1)
		{
			Location *location = [[Location alloc] init];
			location.X = LocX;
			location.Y = LocY;
			
			[self.list addObject: location];
		}
	}
}

- (void)removeAll
{
	[self.list removeAllObjects];
}

- (Location *)getLocationByX: (int)x y: (int)y
{
	Location *location = nil;
	
	for (Location *loc in self.list)
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
	
	for (Location *loc in self.list)
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

- (Location *)getGridLocationFromTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns
{
	Location *loc = nil;
	
	CGRect segmentRect = CGRectZero, touchRect = CGRectZero;
	
	for (Location *location in self.list)
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
	
	for (Location *location in self.list)
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
    return [NSString stringWithFormat: @"%@", self.list];
}

@end













