//
//  MAMaze.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FFEF/FatFractal.h>

#import "MALocation.h"

@class MACoordinate;
@class MASound;
@class MASize;
@class MATexture;
@class MAWall;

@interface MAMaze : NSObject <FFAnnotation>

@property (readwrite, strong, nonatomic) NSString *mazeId;
@property (readwrite, strong, nonatomic) id<FFUserProtocol> user;
@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, strong, nonatomic) MASize *size;
@property (readwrite, assign, nonatomic) BOOL public;
@property (readwrite, strong, nonatomic) MASound *backgroundSound;
@property (readwrite, strong, nonatomic) MATexture *wallTexture;
@property (readwrite, strong, nonatomic) MATexture *floorTexture;
@property (readwrite, strong, nonatomic) MATexture *ceilingTexture;
@property (readwrite, assign, nonatomic) float averageRating;
@property (readwrite, assign, nonatomic) int ratingCount;
@property (readwrite, strong, nonatomic) NSDate *modifiedAt;

@property (readwrite, assign, nonatomic) NSUInteger rows;
@property (readwrite, assign, nonatomic) NSUInteger columns;

@property (readwrite, strong, nonatomic) NSData *locationsData;
@property (readonly, strong, nonatomic) MALocation *startLocation;
@property (readonly, strong, nonatomic) MALocation *endLocation;
@property (readwrite, strong, nonatomic) MALocation *previousSelectedLocation;
@property (readwrite, strong, nonatomic) MALocation *currentSelectedLocation;

@property (readwrite, strong, nonatomic) NSData *wallsData;
@property (readwrite, strong, nonatomic) MAWall *currentSelectedWall;

+ (MAMaze *)mazeWithLoggedInUser: (id<FFUserProtocol>)loggedInUser
                            rows: (NSUInteger)rows
                         columns: (NSUInteger)columns
                 backgroundSound: (MASound *)backgroundSound
                     wallTexture: (MATexture *)wallTexture
                    floorTexture: (MATexture *)floorTexture
                  ceilingTexture: (MATexture *)ceilingTexture;

- (void)reset;

- (void)updateWithMaze: (MAMaze *)maze;

- (void)populateLocationsAndWalls;

- (MALocation *)locationWithLocationId: (NSString *)locationId;
- (MALocation *)locationWithRow: (NSUInteger)row column: (NSUInteger)column;

- (BOOL)isValidLocationWithRow: (NSUInteger)row
                        column: (NSUInteger)column;

- (NSArray *)allLocations;
- (void)removeAllLocations;

- (void)resetLocation: (MALocation *)location;

- (void)compressLocationsAndWallsData;
- (void)decompressLocationsDataAndWallsData;

- (MAWall *)wallWithRow: (NSUInteger)row
                 column: (NSUInteger)column
              direction: (MADirectionType)direction;

- (BOOL)isValidWallWithRow: (NSUInteger)row
                    column: (NSUInteger)column
                 direction: (MADirectionType)direction;

- (NSArray *)allWalls;

- (BOOL)isSurroundedByWallsWithLocation: (MALocation *)location;

- (BOOL)isInnerWall: (MAWall *)wall;

@end















