//
//  MAMaze.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAMaze.h"

#import "MACoordinate.h"
#import "MAFloorPlanStyle.h"
#import "MASize.h"
#import "MASound.h"
#import "MATexture.h"
#import "MAUtilities.h"
#import "MAWall.h"

@interface MAMaze ()

@property (readwrite, strong, nonatomic) NSArray *locations;
@property (readonly, strong, nonatomic) NSDictionary *locationsDictionary;

@property (readwrite, strong, nonatomic) NSArray *walls;
@property (readonly, strong, nonatomic) NSDictionary *wallsDictionary;

@end

@implementation MAMaze

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _mazeId = nil;
        _user = nil;
        _name = nil;
        _size = nil;
        _public = NO;
        _backgroundSound = nil;
        _wallTexture = nil;
        _floorTexture = nil;
        _ceilingTexture = nil;
        _averageRating = 0.0;
        _ratingCount = 0;
        _modifiedAt = nil;
        
        _locations = nil;
        _locationsDictionary = nil;
        _locationsData = nil;
        
        _walls = nil;
        _wallsDictionary = nil;
        _wallsData = nil;
    }
    
    return self;
}

- (BOOL)shouldSerialize: (NSString *)propertyName
{
    if ([propertyName isEqualToString: @"rows"] ||
        [propertyName isEqualToString: @"columns"] ||
        [propertyName isEqualToString: @"startLocation"] ||
        [propertyName isEqualToString: @"endLocation"] ||
        [propertyName isEqualToString: @"locations"] ||
        [propertyName isEqualToString: @"locationsDictionary"] ||
        [propertyName isEqualToString: @"walls"] ||
        [propertyName isEqualToString: @"wallsDictionary"])
    {
        return NO;
    }
    else
    {        
        return YES;
    }
}

- (NSUInteger)rows
{
    return self.size.rows;
}

- (void)setRows: (NSUInteger)rows
{
    self.size.rows = rows;
}

- (NSUInteger)columns
{
    return self.size.columns;
}

- (void)setColumns: (NSUInteger)columns
{
    self.size.columns = columns;
}

- (MALocation *)startLocation
{
    return [self locationWithAction: MALocationActionStart];
}

- (MALocation *)endLocation
{
    return [self locationWithAction: MALocationActionEnd];
}

+ (MAMaze *)mazeWithLoggedInUser: (id<FFUserProtocol>)loggedInUser
                            rows: (NSUInteger)rows
                         columns: (NSUInteger)columns
                 backgroundSound: (MASound *)backgroundSound
                     wallTexture: (MATexture *)wallTexture
                    floorTexture: (MATexture *)floorTexture
                  ceilingTexture: (MATexture *)ceilingTexture
{
    MAMaze *maze = [[MAMaze alloc] init];
    
    maze.mazeId = [MAUtilities createUUIDString];
    maze.user = loggedInUser;
    maze.name = @"";
    
    maze.size = [[MASize alloc] init];
    maze.rows = rows;
    maze.columns = columns;
    
    maze.public = NO;
    maze.backgroundSound = backgroundSound;
    maze.wallTexture = wallTexture;
    maze.floorTexture = floorTexture;
    maze.ceilingTexture = ceilingTexture;
    maze.averageRating = -1;
    maze.ratingCount = 0;
    maze.modifiedAt = [NSDate date];
    
    maze.locationsData = nil;
    maze.wallsData = nil;
    
    [maze populateLocationsAndWalls];
    
    return maze;
}

- (void)reset
{
    self.public = NO;
    
    self.locationsData = nil;
    self.wallsData = nil;
    
    [self populateLocationsAndWalls];
}

- (void)updateWithMaze: (MAMaze *)maze
{
    self.mazeId = maze.mazeId;
    self.user = maze.user;
    self.name = maze.name;
    self.size = maze.size;
    self.public = maze.public;
    self.backgroundSound = maze.backgroundSound;
    self.wallTexture = maze.wallTexture;
    self.floorTexture = maze.floorTexture;
    self.ceilingTexture = maze.ceilingTexture;
    self.modifiedAt = maze.modifiedAt;
    
    self.locations = maze.locations;
    [self createLocationsDictionary];
    self.locationsData = maze.locationsData;
    
    self.walls = maze.walls;
    [self createWallsDictionary];
    self.wallsData = maze.wallsData;
}

- (void)populateLocationsAndWalls
{
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    NSMutableArray *walls = [[NSMutableArray alloc] init];
    
    for (NSUInteger row = 1; row <= self.rows + 1; row = row + 1)
    {
        for (NSUInteger column = 1; column <= self.columns + 1; column = column + 1)
        {
            MACoordinate *coordinate = [[MACoordinate alloc] init];
            coordinate.row = row;
            coordinate.column = column;
            
            MALocation *location = [[MALocation alloc] init];
            location.locationId = [MAUtilities createUUIDString];
            location.coordinate = coordinate;
            location.action = MALocationActionDoNothing;
            location.message = @"";
            
            [locations addObject: location];
            
            if (column <= self.columns)
            {
                MAWall *northWall = [[MAWall alloc] init];
                northWall.coordinate = coordinate;
                northWall.direction = MADirectionNorth;
                
                if (row == 1 || row == self.rows + 1)
                {
                    northWall.type = MAWallBorder;
                }
                else
                {
                    northWall.type = MAWallSolid;
                }
                
                [walls addObject: northWall];
            }
            
            if (row <= self.rows)
            {
                MAWall *westWall = [[MAWall alloc] init];
                westWall.coordinate = coordinate;
                westWall.direction = MADirectionWest;
                
                if (column == 1 || column == self.columns + 1)
                {
                    westWall.type = MAWallBorder;
                }
                else
                {
                    westWall.type = MAWallSolid;
                }

                [walls addObject: westWall];
            }
        }
    }
    
    self.locations = locations;
    [self createLocationsDictionary];

    self.walls = walls;
    [self createWallsDictionary];
}

- (void)compressLocationsAndWallsData
{
    NSError *error = nil;
    
    // locations
    NSData *decompressedLocationsData = [NSKeyedArchiver archivedDataWithRootObject: self.locations];
    
    NSData *compressedLocationsData = [BZipCompression compressedDataWithData: decompressedLocationsData
                                                                    blockSize: BZipDefaultBlockSize
                                                                   workFactor: BZipDefaultWorkFactor
                                                                        error: &error];
    
    if (error != nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Unable to compress locations data."
                       parameters: @{@"error" : error}];
    }
    
    self.locationsData = compressedLocationsData;
    
    // walls
    NSData *decompressedWallsData = [NSKeyedArchiver archivedDataWithRootObject: self.walls];
    
    NSData *compressedWallsData = [BZipCompression compressedDataWithData: decompressedWallsData
                                                                blockSize: BZipDefaultBlockSize
                                                               workFactor: BZipDefaultWorkFactor
                                                                    error: &error];
    
    if (error != nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Unable to compress walls data."
                       parameters: @{@"error" : error}];
    }
    
    self.wallsData = compressedWallsData;
}

- (void)decompressLocationsDataAndWallsData
{
    NSError *error = nil;
    
    //locations
    NSData *compressedLocationsData = self.locationsData;
    
    NSData *decompressedLocationsData = [BZipCompression decompressedDataWithData: compressedLocationsData
                                                                            error: &error];
    
    if (error != nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Unable to decompress locations data."
                       parameters: @{@"maze" : self,
                                     @"error" : error}];
    }
    
    self.locations = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: decompressedLocationsData];
    [self createLocationsDictionary];
    
    // walls
    NSData *compressedWallsData = self.wallsData;
    
    NSData *decompressedWallsData = [BZipCompression decompressedDataWithData: compressedWallsData
                                                                        error: &error];
    
    if (error != nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Unable to decompress walls data."
                       parameters: @{@"maze" : self,
                                     @"error" : error}];
    }
    
    self.walls = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: decompressedWallsData];
    [self createWallsDictionary];
}

#pragma mark - searching for a location by row and column

- (void)createLocationsDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (MALocation *location in self.locations)
    {
        NSString *hash = [self locationHashWithRow: location.row
                                            column: location.column];

        [dictionary setObject: location forKey: hash];
    }
    
    _locationsDictionary = dictionary;
}

- (MALocation *)locationWithRow: (NSUInteger)row column: (NSUInteger)column
{
    NSString *hash = [self locationHashWithRow: row column: column];

    MALocation *location = [self.locationsDictionary objectForKey: hash];
    
    if (location == nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Could not find location."
                       parameters: @{@"maze" : self,
                                     @"row" : @(row),
                                     @"column" : @(column)}];
    }

    return location;
}

- (NSString *)locationHashWithRow: (NSUInteger)row column: (NSUInteger)column
{
    NSString *hash = [NSString stringWithFormat: @"%d,%d", row, column];

    return hash;
}

#pragma mark -

- (MALocation *)locationWithAction: (MALocationActionType)action
{
    MALocation *location = nil;
    
    for (MALocation *someLocation in self.locations)
    {
        if (someLocation.action == action)
        {
            location = someLocation;
        }
    }
    
    if (location == nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Could not find location."
                       parameters: @{@"maze" : self,
                                     @"action" : @(action)}];
    }

    return location;
}

- (BOOL)isValidLocationWithRow: (NSUInteger)row
                        column: (NSUInteger)column
{
    if (row >= 1 && row <= self.rows && column >= 1 && column <= self.columns)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSArray *)allLocations
{
    return self.locations;
}

- (void)resetLocation: (MALocation *)location
{
    MALocation *teleportToLocation = nil;
    
    if (location.action == MALocationActionTeleport)
    {
        teleportToLocation = [self locationWithRow: location.teleportY
                                            column: location.teleportX];
    }
    
    [location reset];
    
    if (teleportToLocation != nil)
    {
        [teleportToLocation reset];
    }
}

#pragma mark - searching for a wall by row, column and direction

- (void)createWallsDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (MAWall *wall in self.walls)
    {
        NSString *hash = [self wallHashWithRow: wall.row
                                        column: wall.column
                                     direction: wall.direction];
        
        [dictionary setObject: wall forKey: hash];
    }
    
    _wallsDictionary = dictionary;
}

- (MAWall *)wallWithRow: (NSUInteger)row
                 column: (NSUInteger)column
              direction: (MADirectionType)direction
{
    switch (direction)
    {
        case MADirectionNorth:
        case MADirectionWest:
            break;
            
        case MADirectionSouth:
            row = row + 1;
            direction = MADirectionNorth;
            break;
            
        case MADirectionEast:
            column = column + 1;
            direction = MADirectionWest;
            break;
            
        default:
            [MAUtilities logWithClass: [self class]
                              message: @"direction set to an illegal value."
                           parameters: @{@"maze" : self,
                                         @"direction" : @(direction)}];
            break;
    }
    
    NSString *hash = [self wallHashWithRow: row
                                    column: column
                                 direction: direction];
    
    MAWall *wall = [self.wallsDictionary objectForKey: hash];
    
    if (wall == nil)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Could not find wall."
                       parameters: @{@"maze" : self,
                                     @"row" : @(row),
                                     @"column" : @(column),
                                     @"direction" : @(direction)}];
    }
    
    return wall;
}

- (NSString *)wallHashWithRow: (NSUInteger)row
                       column: (NSUInteger)column
                    direction: (MADirectionType)direction
{
    NSString *hash = [NSString stringWithFormat: @"%d,%d,%d", row, column, direction];
    
    return hash;
}

#pragma mark -

- (BOOL)isValidWallWithRow: (NSUInteger)row
                    column: (NSUInteger)column
                 direction: (MADirectionType)direction;
{
    if ((row >= 1 && row <= self.rows && column >= 1 && column <= self.columns) ||
        (row == 0 && column >= 1 && column <= self.columns && direction == MADirectionSouth) ||
        (row == self.rows + 1 && column >= 1 && column <= self.columns && direction == MADirectionNorth) ||
        (column == 0 && row >= 1 && row <= self.rows && direction == MADirectionEast) ||
        (column == self.columns + 1 && row >= 1 && row <= self.rows && direction == MADirectionWest))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSArray *)allWalls
{
    return self.walls;
}

- (BOOL)isLocationSurroundedByWalls:(MALocation *)location
{
    MAWall *wallNorth = [self wallWithRow: location.row
                                   column: location.column
                                direction: MADirectionNorth];
    
    MAWall *wallSouth = [self wallWithRow: location.row
                                   column: location.column
                                direction: MADirectionSouth];
    
    MAWall *wallEast = [self wallWithRow: location.row
                                  column: location.column
                               direction: MADirectionEast];
    
    MAWall *wallWest = [self wallWithRow: location.row
                                  column: location.column
                               direction: MADirectionWest];
    
    if ((wallNorth.type == MAWallSolid || wallNorth.type == MAWallBorder || wallNorth.type == MAWallInvisible) &&
        (wallEast.type == MAWallSolid || wallEast.type == MAWallBorder || wallEast.type == MAWallInvisible) &&
        (wallSouth.type == MAWallSolid || wallSouth.type == MAWallBorder || wallSouth.type == MAWallInvisible) &&
        (wallWest.type == MAWallSolid || wallWest.type == MAWallBorder || wallWest.type == MAWallInvisible))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isInnerWall: (MAWall *)wall
{
    if ((wall.row == self.rows + 1) ||
        (wall.column == self.columns + 1) ||
        (wall.row == 1 && wall.direction == MADirectionNorth) ||
        (wall.column == 1 && wall.direction == MADirectionWest))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)isEqual: (id)object
{
    if ([object isKindOfClass: [MAMaze class]])
    {
        MAMaze *maze = object;
        
        return [self.mazeId isEqualToString: maze.mazeId];
    }
    
    return NO;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p;\n", [self class], self];
    desc = [desc stringByAppendingFormat: @"\tmazeId = %@;\n", self.mazeId];
    desc = [desc stringByAppendingFormat: @"\tuser = %@;\n", self.user];
    desc = [desc stringByAppendingFormat: @"\tname = %@;\n", self.name];
    desc = [desc stringByAppendingFormat: @"\tsize = %@;\n", self.size];
    desc = [desc stringByAppendingFormat: @"\tpublic = %d;\n", self.public];
    desc = [desc stringByAppendingFormat: @"\tbackgroundSound.soundId = %@;\n", self.backgroundSound.soundId];
    desc = [desc stringByAppendingFormat: @"\twallTexture.textureId = %@;\n", self.wallTexture.textureId];
    desc = [desc stringByAppendingFormat: @"\tfloorTexture.textureId = %@;\n", self.floorTexture.textureId];
    desc = [desc stringByAppendingFormat: @"\tceilingTexture.textureId = %@;\n", self.ceilingTexture.textureId];
    desc = [desc stringByAppendingFormat: @"\taverageRating = %f;\n", self.averageRating];
    desc = [desc stringByAppendingFormat: @"\tratingCount = %d;\n", self.ratingCount];

    desc = [desc stringByAppendingFormat: @"\tstartLocation = %@;\n", self.startLocation];
    desc = [desc stringByAppendingFormat: @"\tendLocation = %@;\n", self.endLocation];

    desc = [desc stringByAppendingFormat: @"\tlocationsData.length = %d;\n", self.locationsData.length];
    desc = [desc stringByAppendingFormat: @"\tlocations = %@;\n", self.locations];
    
    desc = [desc stringByAppendingFormat: @"\twalls = %@>", self.walls];
    desc = [desc stringByAppendingFormat: @"\twallsData.length = %d;\n", self.wallsData.length];

    return desc;
}

@end




















