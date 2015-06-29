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
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"
#import "MAWorld.h"

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
        
        _world = nil;
        
        _currentLocation = nil;
        _facingDirection = MADirectionUnknown;

        [self setupNearbyLocations];
        [self setupNearbyWalls];
    }
    
    return self;
}

- (CGSize)mapSize
{
    return CGSizeMake(self.styles.map.locationLength * self.world.columns + self.styles.map.wallWidth * (self.world.columns + 1),
                      self.styles.map.locationLength * self.world.rows + self.styles.map.wallWidth * (self.world.rows + 1));
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
                           scale: 1.0];
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
        }
        
        if (locationVisible == YES)
        {
            [self rotateDeltasWithRowDelta: nearbyLocation.rowDelta
                               columnDelta: nearbyLocation.columnDelta
                           facingDirection: self.facingDirection
                           rotatedRowDelta: &rotatedRowDelta
                        rotatedColumnDelta: &rotatedColumnDelta];
            
            MALocation *location = [self.world locationWithRow: self.currentLocation.row + rotatedRowDelta
                                                        column: self.currentLocation.column + rotatedColumnDelta];
            
            CGRect locationFrame =
                CGRectMake((location.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           (location.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                           self.styles.map.locationLength,
                           self.styles.map.locationLength);
            
            UIColor *locationColor = self.styles.map.doNothingColor;
            
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
            
            // TODO
            
            MAWall *wall = [self.world wallWithRow: self.currentLocation.row + rotatedRowDelta
                                            column: self.currentLocation.column + rotatedColumnDelta
                                          position: MAWallPositionTop    ];
            
            CGRect wallFrame = CGRectZero;
            
            if (wall.position == MAWallPositionTop)
            {
                wallFrame = CGRectMake((wall.column - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth) + self.styles.map.wallWidth,
                                       (wall.row - 1) * (self.styles.map.locationLength + self.styles.map.wallWidth),
                                       self.styles.map.locationLength,
                                       self.styles.map.wallWidth);
            }
            else if (wall.position == MAWallPositionLeft)
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
                               parameters: @{@"wall.position" : @(wall.position)}];
            }
            
            UIColor *wallColor = self.styles.map.wallColor;

            MAMapSegment *wallSegment = [[MAMapSegment alloc] initWithFrame: wallFrame
                                                                      color: wallColor];
            
            [self addSegment: wallSegment];
            
            MALocation *location = [self.world locationWithRow: wall.row
                                                        column: wall.column];
                                    
            [self updateNearbyCornerSegmentsWithLocation: location];
            
            if (wall.position == MAWallPositionTop)
            {
                MALocation *eastLocation = [self.world locationWithRow: wall.row
                                                                column: wall.column + 1];

                [self updateNearbyCornerSegmentsWithLocation: eastLocation];
            }
            else if (wall.position == MAWallPositionLeft)
            {
                MALocation *southLocation = [self.world locationWithRow: wall.row + 1
                                                                 column: wall.column];
                
                [self updateNearbyCornerSegmentsWithLocation: southLocation];
            }
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"Wall direction set to an illegal value."
                               parameters: @{@"wall.position" : @(wall.position)}];
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
    
    UIColor *cornerColor = self.styles.map.wallColor;
    
    MAMapSegment *cornerSegment = [[MAMapSegment alloc] initWithFrame: cornerFrame
                                                                color: cornerColor];
    
    [self addSegment: cornerSegment];
}

- (void)addSegment: (MAMapSegment *)segment
{
    NSString *hash = [NSString stringWithFormat: @"%d,%d", (int)segment.frame.origin.x, (int)segment.frame.origin.y];

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






















