//
//  MAMapView.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAMapView.h"

#import "MALocation.h"
#import "MAMapNearbyLocation.h"
#import "MAMapNearbyWall.h"
#import "MAMapSegment.h"
#import "MAMapStyle.h"
#import "MAMaze.h"
#import "MASize.h"
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"

@interface MAMapView ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (strong, nonatomic) NSMutableArray *nearbyLocations;
@property (strong, nonatomic) NSMutableArray *nearbyWalls;

@property (strong, nonatomic) NSMutableDictionary *segments;

@property (readonly, assign, nonatomic) CGSize mapSize;

@end

@implementation MAMapView

- (id)initWithCoder: (NSCoder*)coder
{    
    self = [super initWithCoder: coder];
    
    if (self) 
    {
        _styles = [MAStyles styles];
        
        _nearbyLocations = [[NSMutableArray alloc] init];
        _nearbyWalls = [[NSMutableArray alloc] init];

        _segments = [[NSMutableDictionary alloc] init];
        
        _maze = nil;
        
        _currentLocation = nil;
        _facingDirection = MADirectionUnknown;

        [self setupNearbyLocations];
        [self setupNearbyWalls];
    }
    
    return self;
}

- (CGSize)mapSize
{
    return CGSizeMake(self.styles.map.locationLength * self.maze.columns + self.styles.map.wallWidth * (self.maze.columns + 1),
                      self.styles.map.locationLength * self.maze.rows + self.styles.map.wallWidth * (self.maze.rows + 1));
}

- (void)setupNearbyLocations
{
    MAMapNearbyLocation *nearbyLocation;

    MAMapNearbyWall *blockingWall1 = nil;
    MAMapNearbyWall *blockingWall2 = nil;
    
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: 0 columnDelta: 0 blockingWalls: @[]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: 0 columnDelta: -1 blockingWalls: @[blockingWall1]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: -1 columnDelta: -1 blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: -1 columnDelta: -1 blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: -1 columnDelta: 0 blockingWalls: @[blockingWall1]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: -1 columnDelta: 1 blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: -1 columnDelta: 1 blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyLocations addObject: nearbyLocation];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    nearbyLocation = [[MAMapNearbyLocation alloc] initWithRowDelta: 0 columnDelta: 1 blockingWalls: @[blockingWall1]];
    [_nearbyLocations addObject: nearbyLocation];
}

- (void)setupNearbyWalls
{
    MAMapNearbyWall *nearbyWall = nil;
    
    MAMapNearbyWall *blockingWall1 = nil;
    MAMapNearbyWall *blockingWall2 = nil;
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionEast blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionSouth blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionWest blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionSouth blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    [_nearbyWalls addObject: nearbyWall];
    
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    [_nearbyWalls addObject: nearbyWall];
    
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    [_nearbyWalls addObject: nearbyWall];
    
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionWest blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionWest blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionSouth blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 0 direction: MADirectionEast blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 1 direction: MADirectionEast blockingWalls: @[blockingWall1]];
    [_nearbyWalls addObject: nearbyWall];
    
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionSouth blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionWest blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionWest blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionEast blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: -1 direction: MADirectionNorth blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionWest blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionNorth blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionNorth blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyWalls addObject: nearbyWall];
    
    blockingWall1 = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionSouth blockingWalls: @[]];
    blockingWall2 = [[MAMapNearbyWall alloc] initWithRowDelta: 0 columnDelta: 0 direction: MADirectionEast blockingWalls: @[]];
    nearbyWall = [[MAMapNearbyWall alloc] initWithRowDelta: -1 columnDelta: 1 direction: MADirectionEast blockingWalls: @[blockingWall1, blockingWall2]];
    [_nearbyWalls addObject: nearbyWall];
}

#pragma mark - UIView

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    self.backgroundColor = self.styles.map.backgroundColor;
}

- (void)drawRect: (CGRect)rect
{
    if (self.segments.count >= 1)
    {
        CGPoint currentMapPosition =
            CGPointMake((self.currentLocation.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth + 0.5 * self.styles.map.locationLength,
                        (self.currentLocation.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth + 0.5 * self.styles.map.locationLength);
        
        CGSize mapOffset = CGSizeZero;
        
        if (self.mapSize.width <= CGRectGetWidth(self.bounds))
        {
            mapOffset.width = (CGRectGetWidth(self.bounds) - self.mapSize.width) / 2.0;
        }
        else if (currentMapPosition.x < CGRectGetWidth(self.bounds) / 2.0)
        {
            mapOffset.width = 0.0;
        }
        else if (currentMapPosition.x > self.mapSize.width - CGRectGetWidth(self.bounds) / 2.0)
        {
            mapOffset.width = CGRectGetWidth(self.bounds) - self.mapSize.width;
        }
        else
        {
            mapOffset.width = CGRectGetWidth(self.bounds) / 2.0 - currentMapPosition.x;
        }
        
        if (self.mapSize.height <= CGRectGetHeight(self.bounds))
        {
            mapOffset.height = (CGRectGetHeight(self.bounds) - self.mapSize.height) / 2.0;
        }
        else if (currentMapPosition.y < CGRectGetHeight(self.bounds) / 2.0)
        {
            mapOffset.height = 0.0;
        }
        else if (currentMapPosition.y > self.mapSize.height - CGRectGetHeight(self.bounds) / 2.0)
        {
            mapOffset.height = CGRectGetHeight(self.bounds) - self.mapSize.height;
        }
        else
        {
            mapOffset.height = CGRectGetHeight(self.bounds) / 2.0 - currentMapPosition.y;
        }

        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (MAMapSegment *segment in [self.segments allValues])
        {
            CGContextSetFillColorWithColor(context, segment.color.CGColor);
            CGContextFillRect(context, CGRectOffset(segment.frame, mapOffset.width, mapOffset.height));
        }
        
        [self drawDirectionArrowWithMapOffset: mapOffset];
    }
}

- (void)drawDirectionArrowWithMapOffset: (CGSize)mapOffset
{
    CGRect arrowFrame = CGRectMake((self.currentLocation.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                                   (self.currentLocation.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                                   self.styles.map.locationLength,
                                   self.styles.map.locationLength);
    
    [MAUtilities drawArrowInRect: CGRectOffset(arrowFrame, mapOffset.width, mapOffset.height)
                    angleDegrees: (self.facingDirection - 1) * 90.0
                           scale: 1.0
                  floorPlanStyle: self.styles.floorPlan];
}

#pragma mark -

- (void)drawSurroundings
{
    [self updateNearbyLocationSegments];
    [self updateNearbyWallSegments];

    [self setNeedsDisplay];
}

- (void)clear
{
    [self.segments removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)updateNearbyLocationSegments
{
    NSUInteger rotatedRowDelta;
    NSUInteger rotatedColumnDelta;
    MADirectionType rotatedDirection;
    
    for (MAMapNearbyLocation *nearbyLocation in self.nearbyLocations)
    {
        BOOL locationVisible = YES;
        
        for (MAMapNearbyWall *blockingWall in nearbyLocation.blockingWalls)
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
            [self rotateDeltasWithRowDelta: nearbyLocation.rowDelta
                               columnDelta: nearbyLocation.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            MALocation *location = [self.maze locationWithRow: self.currentLocation.row + rotatedRowDelta
                                                       column: self.currentLocation.column + rotatedColumnDelta];
            
            CGRect locationFrame =
                CGRectMake((location.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           (location.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           self.styles.map.locationLength,
                           self.styles.map.locationLength);
            
            UIColor *locationColor = nil;
            
            if (location.action == MALocationActionStart)
            {
                locationColor = self.styles.map.startColor;
            }
            else if (location.action == MALocationActionEnd)
            {
                locationColor = self.styles.map.endColor;
            }
            else if (location.action == MALocationActionStartOver && location.visited == YES)
            {
                locationColor = self.styles.map.startOverColor;
            }
            else if (location.action == MALocationActionTeleport && location.visited == YES)
            {
                locationColor = self.styles.map.teleportationColor;
            }
            else
            {
                locationColor = self.styles.map.doNothingColor;
            }
            
            MAMapSegment *locationSegment = [[MAMapSegment alloc] initWithFrame: locationFrame
                                                                          color: locationColor];
            
            [self addSegment: locationSegment];
        }
    }
}

- (void)updateNearbyWallSegments
{
    NSUInteger rotatedRowDelta = 0;
    NSUInteger rotatedColumnDelta = 0;
    MADirectionType rotatedDirection = MADirectionUnknown;
    
    for (MAMapNearbyWall *nearbyWall in self.nearbyWalls)
    {
        BOOL wallVisible = YES;
    
        for (MAMapNearbyWall *blockingWall in nearbyWall.blockingWalls)
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
            [self rotateDeltasWithRowDelta: nearbyWall.rowDelta
                               columnDelta: nearbyWall.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            rotatedDirection = [self rotatedDirectionWithDirection: nearbyWall.direction
                                                   facingDirection: self.facingDirection];
            
            MAWall *wall = [self.maze wallWithRow: self.currentLocation.row + rotatedRowDelta
                                           column: self.currentLocation.column + rotatedColumnDelta
                                        direction: rotatedDirection];
            
            CGRect wallFrame = CGRectZero;
            
            if (wall.direction == MADirectionNorth)
            {
                wallFrame = CGRectMake((wall.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                                       (wall.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth),
                                       self.styles.map.locationLength,
                                       self.styles.map.wallWidth);
            }
            else if (wall.direction == MADirectionWest)
            {
                wallFrame = CGRectMake((wall.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth),
                                       (wall.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                                       self.styles.map.wallWidth,
                                       self.styles.map.locationLength);
            }
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"Wall direction set to an illegal value."
                               parameters: @{@"wall.direction" : @(wall.direction)}];
            }
            
            UIColor *wallColor = nil;
            
            if (wall.type == MAWallSolid || wall.type == MAWallBorder || wall.type == MAWallFake)
            {                
                wallColor = self.styles.map.wallColor;
            }
            else if (wall.type == MAWallInvisible && wall.hit == YES)
            {
                wallColor = self.styles.map.invisibleColor;
            }
            else if (wall.type == MAWallNone || wall.type == MAWallInvisible)
            {
                wallColor = self.styles.map.noWallColor;
            }

            MAMapSegment *wallSegment = [[MAMapSegment alloc] initWithFrame: wallFrame
                                                                      color: wallColor];
            
            [self addSegment: wallSegment];
            
            MALocation *location = [self.maze locationWithRow: wall.row
                                                       column: wall.column];
                                    
            [self updateNearbyCornerSegmentsWithLocation: location];
            
            if (wall.direction == MADirectionNorth)
            {
                MALocation *eastLocation = [self.maze locationWithRow: wall.row
                                                               column: wall.column + 1];

                [self updateNearbyCornerSegmentsWithLocation: eastLocation];
            }
            else if (wall.direction == MADirectionWest)
            {
                MALocation *southLocation = [self.maze locationWithRow: wall.row + 1
                                                                column: wall.column];
                
                [self updateNearbyCornerSegmentsWithLocation: southLocation];
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

- (void)updateNearbyCornerSegmentsWithLocation: (MALocation *)location
{
    CGRect cornerFrame = CGRectMake((location.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth),
                                    (location.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth),
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
    
    UIColor *cornerColor = nil;
    
    if ((northWall.type == MAWallNone || (northWall.type == MAWallInvisible && northWall.hit == NO)) &&
        (eastWall.type == MAWallNone || (eastWall.type == MAWallInvisible && eastWall.hit == NO)) &&
        (southWall.type == MAWallNone || (southWall.type == MAWallInvisible && southWall.hit == NO)) &&
        (westWall.type == MAWallNone || (westWall.type == MAWallInvisible && westWall.hit == NO)))
    {
        cornerColor = self.styles.map.noWallColor;
    }
    else if (northWall.type == MAWallSolid || northWall.type == MAWallBorder || northWall.type == MAWallFake ||
             eastWall.type == MAWallSolid || eastWall.type == MAWallBorder || eastWall.type == MAWallFake ||
             southWall.type == MAWallSolid || southWall.type == MAWallBorder || southWall.type == MAWallFake ||
             westWall.type == MAWallSolid || westWall.type == MAWallBorder || westWall.type == MAWallFake)
    {
        cornerColor = self.styles.map.wallColor;
    }
    else if ((northWall.type == MAWallInvisible && northWall.hit == YES) ||
             (eastWall.type == MAWallInvisible && eastWall.hit == YES) ||
             (southWall.type == MAWallInvisible && southWall.hit == YES) ||
             (westWall.type == MAWallInvisible && westWall.hit == YES))
    {
        cornerColor = self.styles.map.invisibleColor;
    }
    else 
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Map corner not handled."
                       parameters: @{@"location" : [MAUtilities objectOrNull: location],
                                     @"maze" : [MAUtilities objectOrNull: self.maze]}];
    }
    
    MAMapSegment *cornerSegment = [[MAMapSegment alloc] initWithFrame: cornerFrame
                                                                color: cornerColor];
    
    [self addSegment: cornerSegment];
}

- (void)addSegment: (MAMapSegment *)segment
{
    NSString *hash = [NSString stringWithFormat: @"%d,%d", (NSUInteger)segment.frame.origin.x, (NSUInteger)segment.frame.origin.y];

    [self.segments setObject: segment
                      forKey: hash];
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






















