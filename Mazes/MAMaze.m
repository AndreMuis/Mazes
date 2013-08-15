//
//  MAMaze.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAMaze.h"

#import "MASound.h"
#import "MATexture.h"
#import "MAUser.h"
#import "MAUtilities.h"
#import "Styles.h"

#import <Parse/PFObject+Subclass.h>
 
@implementation MAMaze

@dynamic user;
@dynamic name;
@dynamic rows;
@dynamic columns;
@dynamic active;
@dynamic public;
@dynamic backgroundSound;
@dynamic wallTexture;
@dynamic floorTexture;
@dynamic ceilingTexture;
@dynamic averageRating;
@dynamic ratingCount;

@synthesize locations;
@synthesize locationCount;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (id)init
{
	self = [super init];
	
    if (self)
	{
        self.locations = [[NSMutableArray alloc] init];
        self.locationCount = nil;
	}
	
	return self;
}

- (void)setWallTextureIdWithNumber: (NSNumber *)textureId
{
	self.wallTexture = nil;
}

- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId
{
	self.floorTexture = nil;
}

- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId
{
	self.ceilingTexture = nil;
}

- (void)populateWithRows: (int)rows columns: (int)columns
{
    [self.locations removeAllObjects];
    
	for (int locationX = 1; locationX <= self.columns + 1; locationX = locationX + 1)
	{
		for (int locationY = 1; locationY <= rows + 1; locationY = locationY + 1)
		{
			MALocation *location = [[MALocation alloc] init];
			location.xx = locationX;
			location.yy = locationY;
			
			[self.locations addObject: location];
		}
	}
}

- (void)removeAllLocations
{
	[self.locations removeAllObjects];
}

- (MALocation *)locationWithLocationX: (int)locationX locationY: (int)locationY
{
	MALocation *locationRet = nil;
	
	for (MALocation *location in self.locations)
	{
		if (location.xx == locationX && location.yy == locationY)
        {
			locationRet = location;
        }
	}
	
	return locationRet;
}

- (MALocation *)locationWithAction: (MALocationActionType)action
{
	MALocation *locationRet = nil;
	
	for (MALocation *location in self.locations)
	{
		if (location.action == action)
        {
			locationRet = location;
        }
	}
    
	return locationRet;
}

- (BOOL)isSurroundedByWallsWithLocation: (MALocation *)location
{
	BOOL surrounded = NO;
	
	MAWallType wallTypeNorth = [self wallTypeWithLocationX: location.xx
                                                 locationY: location.yy
                                                 direction: MADirectionNorth];
    
	MAWallType wallTypeEast = [self wallTypeWithLocationX: location.xx
                                                locationY: location.yy
                                                direction: MADirectionEast];
    
	MAWallType wallTypeSouth = [self wallTypeWithLocationX: location.xx
                                                 locationY: location.yy
                                                 direction: MADirectionSouth];
    
	MAWallType wallTypeWest = [self wallTypeWithLocationX: location.xx
                                                locationY: location.yy
                                                direction: MADirectionWest];
    
	if ((wallTypeNorth == MAWallSolid || wallTypeNorth == MAWallInvisible) &&
		(wallTypeEast == MAWallSolid || wallTypeEast == MAWallInvisible) &&
		(wallTypeSouth == MAWallSolid || wallTypeSouth == MAWallInvisible) &&
		(wallTypeWest == MAWallSolid || wallTypeWest == MAWallInvisible))
	{
		surrounded = YES;
	}
    
	return surrounded;
}

- (MAWallType)wallTypeWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction
{
	int type = 0;
	MALocation *location = nil;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self locationWithLocationX: locationX locationY: locationY];
            type = location.wallNorth;
            break;
            
        case MADirectionWest:
            location = [self locationWithLocationX: locationX locationY: locationY];
            type = location.wallWest;
            break;
            
        case MADirectionSouth:
            location = [self locationWithLocationX: locationX locationY: locationY + 1];
            type = location.wallNorth;
            break;
            
        case MADirectionEast:
            location = [self locationWithLocationX: locationX + 1 locationY: locationY];
            type = location.wallWest;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
    
	return type;
}

- (BOOL)hasHitWallWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction
{
	MALocation *location = nil;
	BOOL hitWall = NO;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self locationWithLocationX: locationX locationY: locationY];
            hitWall = location.wallNorthHit;
            break;
            
        case MADirectionWest:
            location = [self locationWithLocationX: locationX locationY: locationY];
            hitWall = location.wallWestHit;
            break;
            
        case MADirectionSouth:
            location = [self locationWithLocationX: locationX locationY: locationY + 1];
            hitWall = location.wallNorthHit;
            break;
            
        case MADirectionEast:
            location = [self locationWithLocationX: locationX + 1 locationY: locationY];
            hitWall = location.wallWestHit;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
    
	
	return hitWall;
}

- (BOOL)isInnerWallWithLocation: (MALocation *)location rows: (int)rows columns: (int)columns wallDir: (MADirectionType)wallDir
{
	BOOL val;
	
	if ((location.xx == 1 && location.yy >= 2 && location.yy <= rows && wallDir == MADirectionNorth) ||
		(location.yy == 1 && location.xx >= 2 && location.xx <= columns && wallDir == MADirectionWest) ||
		(location.xx >= 2 && location.xx <= columns && location.yy >= 2 && location.yy <= rows))
    {
		val = YES;
    }
	else
    {
		val = NO;
    }
    
	return val;
}

- (void)setWallTypeWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction type: (MAWallType)type
{
	MALocation *location = nil;
    
    switch (direction)
    {
        case MADirectionNorth:
            location = [self locationWithLocationX: locationX locationY: locationY];
            location.WallNorth = type;
            break;
            
        case MADirectionWest:
            location = [self locationWithLocationX: locationX locationY: locationY];
            location.WallWest = type;
            break;
            
        case MADirectionSouth:
            location = [self locationWithLocationX: locationX locationY: locationY + 1];
            location.WallNorth = type;
            break;
            
        case MADirectionEast:
            location = [self locationWithLocationX: locationX + 1 locationY: locationY];
            location.WallWest = type;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
}

- (void)setWallHitWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction
{
	MALocation *location = nil;
	
    switch (direction)
    {
        case MADirectionNorth:
            location = [self locationWithLocationX: locationX locationY: locationY];
            location.WallNorthHit = YES;
            break;
            
        case MADirectionWest:
            location = [self locationWithLocationX: locationX locationY: locationY];
            location.WallWestHit = YES;
            break;
            
        case MADirectionSouth:
            location = [self locationWithLocationX: locationX locationY: locationY + 1];
            location.WallNorthHit = YES;
            break;
            
        case MADirectionEast:
            location = [self locationWithLocationX: locationX + 1 locationY: locationY];
            location.WallWestHit = YES;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"direction set to an illegal value: %d", direction];
            break;
    }
}

- (MALocation *)gridLocationWithTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns
{
	MALocation *locationRet = nil;
	
	CGRect segmentRect = CGRectZero, touchRect = CGRectZero;
	
	for (MALocation *location in self.locations)
	{
		segmentRect = [self segmentRectWithLocation: location segmentType: MAMazeObjectLocation];
        
		touchRect = CGRectMake(segmentRect.origin.x - [Styles shared].grid.segmentLengthShort / 2.0, segmentRect.origin.y - [Styles shared].grid.segmentLengthShort / 2.0, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort, [Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
		
		if (CGRectContainsPoint(touchRect, touchPoint) && location.xx <= columns && location.yy <= rows)
		{
			locationRet = location;
			break;
		}
	}
    
	return locationRet;
}

- (MALocation *)gridWallLocationWithSegType: (MAMazeObjectType *)segType touchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns
{
	CGRect segmentRect = CGRectZero;
	CGPoint segmentOrigin = CGPointZero;
	
	float tx = 0.0, ty = 0.0;
	float b = ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort) / 2.0;
	
	for (MALocation *location in self.locations)
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
			
			segmentRect = [self segmentRectWithLocation: location segmentType: *segType];
			
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
				if ((location.xx <= columns && location.yy <= rows) ||
					(location.xx == columns + 1 && *segType == MAMazeObjectWallWest && location.yy <= rows) ||
					(location.yy == rows + 1 && *segType == MAMazeObjectWallNorth && location.xx <= columns))
				{
					return location;
				}
			}
		}
	}
    
	return nil;
}

- (CGRect)segmentRectWithLocation: (MALocation *)location segmentType: (MAMazeObjectType)segmentType
{
	float segmentX = 0.0, segmentY = 0.0, width = 0.0, height = 0.0;
	
    switch (segmentType)
    {
        case MAMazeObjectLocation:
            segmentX = [Styles shared].grid.segmentLengthShort + (location.xx - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            segmentY = [Styles shared].grid.segmentLengthShort + (location.yy - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            
            width = [Styles shared].grid.segmentLengthLong;
            height = [Styles shared].grid.segmentLengthLong;
            
            break;
            
        case MAMazeObjectWallNorth:
            segmentX = [Styles shared].grid.segmentLengthShort + (location.xx - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            segmentY = (location.yy - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            
            width = [Styles shared].grid.segmentLengthLong;
            height = [Styles shared].grid.segmentLengthShort;
            
            break;
            
        case MAMazeObjectWallWest:
            segmentX = (location.xx - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            segmentY = [Styles shared].grid.segmentLengthShort + (location.yy - 1) * ([Styles shared].grid.segmentLengthShort + [Styles shared].grid.segmentLengthLong);
            
            width = [Styles shared].grid.segmentLengthShort;
            height = [Styles shared].grid.segmentLengthLong;
            
            break;
            
        case MAMazeObjectCorner:
            
            segmentX = (location.xx - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            segmentY = (location.yy - 1) * ([Styles shared].grid.segmentLengthLong + [Styles shared].grid.segmentLengthShort);
            
            width = [Styles shared].grid.segmentLengthShort;
            height = [Styles shared].grid.segmentLengthShort;
            
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"segmentType set to an illegal value: %d", segmentType];
            break;
    }
    
	return CGRectMake(segmentX, segmentY, width, height);
}

/*
- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"user.objectId = %@", self.user.objectId];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, rows = %d", desc, self.rows];
    desc = [NSString stringWithFormat: @"%@, columns = %d", desc, self.columns];
    desc = [NSString stringWithFormat: @"%@, public = %d", desc, self.public];
    desc = [NSString stringWithFormat: @"%@, backgroundSound.objectId = %@", desc, self.backgroundSound.objectId];
    desc = [NSString stringWithFormat: @"%@, wallTexture.objectId = %@", desc, self.wallTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, floorTexture.objectId = %@", desc, self.floorTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, ceilingTexture.objectId = %@", desc, self.ceilingTexture.objectId];
    desc = [NSString stringWithFormat: @"%@, averageRating = %f", desc, self.averageRating];
    desc = [NSString stringWithFormat: @"%@, ratingCount = %d", desc, self.ratingCount];

    desc = [NSString stringWithFormat: @"%@, locations = %@", desc, self.locations];
    desc = [NSString stringWithFormat: @"%@, locationCount = %@", desc, self.locationCount];

    return desc;
    
    return @"";
}
*/

@end




















