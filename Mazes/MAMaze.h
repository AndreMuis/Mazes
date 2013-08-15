//
//  MAMaze.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

#import "MALocation.h"

@class MASound;
@class MATexture;
@class MAUser;

typedef enum : int
{
	MAMazeObjectLocation = 1,
	MAMazeObjectWallNorth = 2,
	MAMazeObjectWallWest = 3,
	MAMazeObjectCorner = 4
} MAMazeObjectType;

@interface MAMaze : PFObject <PFSubclassing>

@property (strong, nonatomic) MAUser *user;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int rows;
@property (assign, nonatomic) int columns;
@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) BOOL public;
@property (strong, nonatomic) MASound *backgroundSound;
@property (strong, nonatomic) MATexture *wallTexture;
@property (strong, nonatomic) MATexture *floorTexture;
@property (strong, nonatomic) MATexture *ceilingTexture;
@property (assign, nonatomic) float averageRating;
@property (assign, nonatomic) int ratingCount;

@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSNumber *locationCount;

+ (NSString *)parseClassName;

- (void)populateWithRows: (int)rows columns: (int)columns;

- (void)removeAllLocations;

- (MALocation *)locationWithLocationX: (int)locationX locationY: (int)locationY;
- (MALocation *)locationWithAction: (MALocationActionType)action;

- (BOOL)isSurroundedByWallsWithLocation: (MALocation *)location;

- (MAWallType)wallTypeWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction;
- (BOOL)hasHitWallWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction;

- (BOOL)isInnerWallWithLocation: (MALocation *)location rows: (int)rows columns: (int)columns wallDir: (MADirectionType)wallDir;

- (void)setWallTypeWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction type: (MAWallType)type;
- (void)setWallHitWithLocationX: (int)locationX locationY: (int)locationY direction: (MADirectionType)direction;


- (MALocation *)gridLocationWithTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns;
- (MALocation *)gridWallLocationWithSegType: (MAMazeObjectType *)segType touchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns;

- (CGRect)segmentRectWithLocation: (MALocation *)location segmentType: (MAMazeObjectType)segmentType;

@end















