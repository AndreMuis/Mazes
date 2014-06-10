//
//  MAMapView.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAMapView.h"

#import "MALocation.h"
#import "MAMapLocation.h"
#import "MAMapStyle.h"
#import "MAMapWall.h"
#import "MAMaze.h"
#import "MASize.h"
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"

@interface MAMapView ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (strong, nonatomic) NSMutableArray *mapLocations;
@property (strong, nonatomic) NSMutableArray *mapWalls;

@end

@implementation MAMapView

- (id)initWithCoder: (NSCoder*)coder
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        _styles = [MAStyles styles];
        
        _mapLocations = [[NSMutableArray alloc] init];
        _mapWalls = [[NSMutableArray alloc] init];
        
        MAMapWall *blockingWall1 = nil;
        MAMapWall *blockingWall2 = nil;

        MAMapLocation *mapLocation;
        
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: 0 columnDelta: 0 blockingWalls: @[]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: 0 columnDelta: -1 blockingWalls: @[blockingWall1]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: -1 columnDelta: -1 blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: -1 columnDelta: -1 blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: -1 columnDelta: 0 blockingWalls: @[blockingWall1]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: -1 columnDelta: 1 blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: -1 columnDelta: 1 blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapLocations addObject: mapLocation];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        mapLocation = [[MAMapLocation alloc] initWithRowDelta: 0 columnDelta: 1 blockingWalls: @[blockingWall1]];
        [_mapLocations addObject: mapLocation];

        
        MAMapWall *mapWall = nil;
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionEast blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionSouth blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
        
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionWest blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionSouth blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
        

        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        [_mapWalls addObject: mapWall];

        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        [_mapWalls addObject: mapWall];

        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        [_mapWalls addObject: mapWall];

        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionWest blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];

        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
        
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionWest blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionEast blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
    
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];

        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionEast blockingWalls: @[blockingWall1]];
        [_mapWalls addObject: mapWall];
    
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionSouth blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionWest blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionEast blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionWest blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapWalls addObject: mapWall];
        
        blockingWall1 = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionSouth blockingWalls: @[]];
        blockingWall2 = [[MAMapWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
        mapWall = [[MAMapWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionEast blockingWalls: @[blockingWall1, blockingWall2]];
        [_mapWalls addObject: mapWall];
    }
	
	return self;
}

- (void)setup
{
    self.backgroundColor = self.styles.map.backgroundColor;
    
    UIImage *directionArrowImage = [MAUtilities createDirectionArrowImageWidth: self.styles.map.squareWidth
                                                                        height: self.styles.map.squareWidth];
    
    _directionArrowImageView = [[UIImageView alloc] initWithImage: directionArrowImage];

    [self addSubview: self.directionArrowImageView];
}

- (void)drawRect: (CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    for (MALocation *location in [self.maze allLocations])
    {
		CGContextSetFillColorWithColor(context, location.mapColor.CGColor);
		CGContextFillRect(context, location.mapRect);

        CGContextSetFillColorWithColor(context, location.mapCornerColor.CGColor);
		CGContextFillRect(context, location.mapCornerRect);
    }
    
	for (MAWall *wall in [self.maze allWalls])
	{
		CGContextSetFillColorWithColor(context, wall.mapColor.CGColor);
		CGContextFillRect(context, wall.mapRect);
	}
}

- (void)clear
{
    for (MALocation *location in [self.maze allLocations])
    {
		location.mapRect = CGRectZero;
		location.mapColor = nil;

		location.mapCornerRect = CGRectZero;
		location.mapColor = nil;
    }
    
	for (MAWall *wall in [self.maze allWalls])
	{
		wall.mapRect = CGRectZero;
		wall.mapColor = nil;
	}
	
	[self setNeedsDisplay];
}

- (void)drawSurroundings
{
	CGPoint mapOffset = CGPointMake((self.styles.map.length - (self.styles.map.squareWidth * self.maze.columns + self.styles.map.wallWidth * (self.maze.columns + 1))) / 2.0,
                                    (self.styles.map.length - (self.styles.map.squareWidth * self.maze.rows + self.styles.map.wallWidth * (self.maze.rows + 1))) / 2.0);
	
    [self setupLocationsWithMapOffset: mapOffset];
    [self setupWallsWithMapOffset: mapOffset];
    
    [self drawDirectionArrowWithMapOffset: mapOffset];

    [self setNeedsDisplay];
}

- (void)setupLocationsWithMapOffset: (CGPoint) mapOffset
{
    NSUInteger rotatedRowDelta;
    NSUInteger rotatedColumnDelta;
    MADirectionType rotatedDirection;
    
    for (MAMapLocation *mapLocation in self.mapLocations)
	{
		BOOL locationVisible = YES;
        
        for (MAMapWall *blockingWall in mapLocation.blockingWalls)
        {
			[self rotateDeltasWithRowDelta: blockingWall.rowDelta
                               columnDelta: blockingWall.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            rotatedDirection = [self rotatedDirectionWithDirection: blockingWall.direction
                                                   facingDirection: self.facingDirection];
            
            BOOL wallValid = [self.maze isValidWallWithRow: self.currentLocation.row + rotatedRowDelta
                                                    column: self.currentLocation.column + rotatedColumnDelta
                                                 direction: rotatedDirection];
            
            if (wallValid == YES)
            {
                MAWall *wall = [self.maze wallWithRow: self.currentLocation.row + rotatedRowDelta
                                               column: self.currentLocation.column + rotatedColumnDelta
                                            direction: rotatedDirection];
                
                if (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake)
                {
					locationVisible = NO;
                }
            }
        }
        
		if (locationVisible == YES)
		{
			[self rotateDeltasWithRowDelta: mapLocation.rowDelta
                               columnDelta: mapLocation.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
			MALocation *location = [self.maze locationWithRow: self.currentLocation.row + rotatedRowDelta
                                                       column: self.currentLocation.column + rotatedColumnDelta];
			
            location.mapRect =
            CGRectMake(mapOffset.x + (location.column - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                       mapOffset.y + (location.row - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                       self.styles.map.squareWidth,
                       self.styles.map.squareWidth);
			
			if (location.action == MALocationActionStart)
            {
                location.mapColor = self.styles.map.startColor;
            }
			else if (location.action == MALocationActionEnd)
            {
				location.mapColor = self.styles.map.endColor;
            }
			else if (location.action == MALocationActionStartOver && location.visited == YES)
            {
				location.mapColor = self.styles.map.startOverColor;
            }
			else if (location.action == MALocationActionTeleport && location.visited == YES)
            {
				location.mapColor = self.styles.map.teleportationColor;
            }
			else
            {
				location.mapColor = self.styles.map.doNothingColor;
            }
		}
	}
}

- (void)setupWallsWithMapOffset: (CGPoint)mapOffset
{
    NSUInteger rotatedRowDelta = 0;
    NSUInteger rotatedColumnDelta = 0;
    MADirectionType rotatedDirection = MADirectionUnknown;
    
	for (MAMapWall *mapWall in self.mapWalls)
	{
		BOOL wallVisible = YES;
	
        for (MAMapWall *blockingWall in mapWall.blockingWalls)
        {
			[self rotateDeltasWithRowDelta: blockingWall.rowDelta
                               columnDelta: blockingWall.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            rotatedDirection = [self rotatedDirectionWithDirection: blockingWall.direction
                                                   facingDirection: self.facingDirection];
            
            BOOL wallValid = [self.maze isValidWallWithRow: self.currentLocation.row + rotatedRowDelta
                                                    column: self.currentLocation.column + rotatedColumnDelta
                                                 direction: rotatedDirection];
            
            if (wallValid == YES)
            {
                MAWall *wall = [self.maze wallWithRow: self.currentLocation.row + rotatedRowDelta
                                               column: self.currentLocation.column + rotatedColumnDelta
                                            direction: rotatedDirection];

                if (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake)
                {
					wallVisible = NO;
                }
            }
        }
        
		if (wallVisible == YES)
		{
            [self rotateDeltasWithRowDelta: mapWall.rowDelta
                               columnDelta: mapWall.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            rotatedDirection = [self rotatedDirectionWithDirection: mapWall.direction
                                                   facingDirection: self.facingDirection];
			
			MAWall *wall = [self.maze wallWithRow: self.currentLocation.row + rotatedRowDelta
                                           column: self.currentLocation.column + rotatedColumnDelta
                                        direction: rotatedDirection];
            
			if (wall.direction == MADirectionNorth)
			{
                wall.mapRect =
                CGRectMake(mapOffset.x + (wall.column - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           mapOffset.y + (wall.row - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth),
                           self.styles.map.squareWidth,
                           self.styles.map.wallWidth);
			}
			else if (wall.direction == MADirectionWest)
			{
                wall.mapRect =
                CGRectMake(mapOffset.x + (wall.column - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth),
                           mapOffset.y + (wall.row - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           self.styles.map.wallWidth,
                           self.styles.map.squareWidth);
			}
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"Wall direction set to an illegal value."
                               parameters: @{@"wall.direction" : @(wall.direction)}];
            }
			
			if (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake)
			{				
				wall.mapColor = self.styles.map.wallColor;
			}
			else if (wall.type == MAWallInvisible && wall.hit == YES)
			{
				wall.mapColor = self.styles.map.invisibleColor;
			}
			else if (wall.type == MAWallNone || wall.type == MAWallInvisible)
			{
				wall.mapColor = self.styles.map.noWallColor;
			}

            MALocation *location = [self.maze locationWithRow: wall.row
                                                       column: wall.column];
                                    
            [self setupCornerWithLocation: location mapOffset: mapOffset];
            
			if (wall.direction == MADirectionNorth)
			{
                MALocation *eastLocation = [self.maze locationWithRow: wall.row
                                                               column: wall.column + 1];

                [self setupCornerWithLocation: eastLocation mapOffset: mapOffset];
			}
			else if (wall.direction == MADirectionWest)
			{
                MALocation *southLocation = [self.maze locationWithRow: wall.row + 1
                                                                column: wall.column];
                
                [self setupCornerWithLocation: southLocation mapOffset: mapOffset];
			}
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"Wall direction set to an illegal value."
                               parameters: @{@"wall.direction" : @(wall.direction)}];
            }
		}
	}	
}

- (void)setupCornerWithLocation: (MALocation *)location mapOffset: (CGPoint)mapOffset
{
    location.mapCornerRect = CGRectMake(mapOffset.x + (location.column - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth),
                                        mapOffset.y + (location.row - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth),
                                        self.styles.map.wallWidth,
                                        self.styles.map.wallWidth);
	
	// relative to corner
    
    MAWall *northWall = nil;
    if ([self.maze isValidWallWithRow: location.row - 1
                               column: location.column
                            direction: MADirectionWest] == YES)
    {
        northWall = [self.maze wallWithRow: location.row - 1
                                    column: location.column
                                 direction: MADirectionWest];
    }
    
    MAWall *eastWall = nil;
    if ([self.maze isValidWallWithRow: location.row
                               column: location.column
                            direction: MADirectionNorth] == YES)
    {
        eastWall = [self.maze wallWithRow: location.row
                                   column: location.column
                                direction: MADirectionNorth];
    }

    MAWall *southWall = nil;
    if ([self.maze isValidWallWithRow: location.row
                               column: location.column
                            direction: MADirectionWest] == YES)
    {
        southWall = [self.maze wallWithRow: location.row
                                    column: location.column
                                 direction: MADirectionWest];
    }
    
    MAWall *westWall = nil;
    if ([self.maze isValidWallWithRow: location.row
                               column: location.column - 1
                            direction: MADirectionNorth] == YES)
    {
        westWall = [self.maze wallWithRow: location.row
                                   column: location.column - 1
                                direction: MADirectionNorth];
	}
    
	if ((northWall.type == MAWallNone || (northWall.type == MAWallInvisible && northWall.hit == NO)) &&
		(eastWall.type == MAWallNone || (eastWall.type == MAWallInvisible && eastWall.hit == NO)) &&
		(southWall.type == MAWallNone || (southWall.type == MAWallInvisible && southWall.hit == NO)) &&
		(westWall.type == MAWallNone || (westWall.type == MAWallInvisible && westWall.hit == NO)))
	{
		location.mapCornerColor = self.styles.map.noWallColor;
	}
	else if (northWall.type == MAWallSolid || northWall.type == MAWallBorder || northWall.type == MAWallFake ||
			 eastWall.type == MAWallSolid || eastWall.type == MAWallBorder || eastWall.type == MAWallFake ||
			 southWall.type == MAWallSolid || southWall.type == MAWallBorder || southWall.type == MAWallFake ||
			 westWall.type == MAWallSolid || westWall.type == MAWallBorder || westWall.type == MAWallFake)
	{
		location.mapCornerColor = self.styles.map.wallColor;
	}
	else if ((northWall.type == MAWallInvisible && northWall.hit == YES) ||
			 (eastWall.type == MAWallInvisible && eastWall.hit == YES) ||
			 (southWall.type == MAWallInvisible && southWall.hit == YES) ||
			 (westWall.type == MAWallInvisible && westWall.hit == YES))
	{
		location.mapCornerColor = self.styles.map.invisibleColor;
	}
	else 
	{
        [MAUtilities logWithClass: [self class]
                          message: @"Map corner not handled."
                       parameters: @{@"location" : [MAUtilities objectOrNull: location],
                                     @"maze" : [MAUtilities objectOrNull: self.maze]}];
	}
}

- (void)drawDirectionArrowWithMapOffset: (CGPoint)mapOffset
{
    self.directionArrowImageView.frame =
    CGRectMake(mapOffset.x + (self.currentLocation.column - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
               mapOffset.y + (self.currentLocation.row - 1) * (self.styles.map.squareWidth + self.styles.map.wallWidth) + self.styles.map.wallWidth,
               self.styles.map.squareWidth,
               self.styles.map.squareWidth);
    
    self.directionArrowImageView.transform = CGAffineTransformMakeRotation((self.facingDirection - 1) * (M_PI / 2.0));
}

- (void)rotateDeltasWithRowDelta: (NSUInteger)rowDelta
                     columnDelta: (NSUInteger)columnDelta
                 facingDirection: (MADirectionType)facingDirection
                 rotatedRowDelta: (NSUInteger *)rotatedRowDelta
              rotatedColumnDelta: (NSUInteger *)rotatedColumnDelta
{
	if (self.facingDirection == MADirectionNorth)
	{
		*rotatedColumnDelta = columnDelta;
		*rotatedRowDelta = rowDelta;
	}
	else if (self.facingDirection == MADirectionEast)
	{
		*rotatedColumnDelta = -rowDelta;
		*rotatedRowDelta = columnDelta;
	}
	else if (self.facingDirection == MADirectionSouth)
	{
		*rotatedColumnDelta = -columnDelta;
		*rotatedRowDelta = -rowDelta;
	}
	else if (self.facingDirection == MADirectionWest)
	{
		*rotatedColumnDelta = rowDelta;
		*rotatedRowDelta = -columnDelta;
	}
}

- (MADirectionType)rotatedDirectionWithDirection: (MADirectionType)direction
                                 facingDirection: (MADirectionType)facingDirection
{
    return ((direction + (facingDirection - 1)) - 1) % 4 + 1;
}

@end






















