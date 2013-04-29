//
//  Location.h
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

typedef enum : int
{
	MALocationActionDoNothing = 0,
	MALocationActionStart = 1,
	MALocationActionEnd = 2,
	MALocationActionStartOver = 3,
	MALocationActionTeleport = 4
} MALocationActionType;

typedef enum : int
{
    MAWallUnknown = 0,
	MAWallNone = 1,
	MAWallSolid = 2,
	MAWallInvisible = 3,
	MAWallFake = 4
} MAWallType;

@interface Location : NSObject 

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int mazeId;
@property (assign, nonatomic) int x;
@property (assign, nonatomic) int y;
@property (assign, nonatomic) int direction;
@property (assign, nonatomic) MAWallType wallNorth;
@property (assign, nonatomic) MAWallType wallWest;
@property (assign, nonatomic) MALocationActionType action;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) int teleportId;
@property (assign, nonatomic) int teleportX;
@property (assign, nonatomic) int teleportY;
@property (assign, nonatomic) int wallNorthTextureId;
@property (assign, nonatomic) int wallWestTextureId;
@property (assign, nonatomic) int floorTextureId;
@property (assign, nonatomic) int ceilingTextureId;
@property (assign, nonatomic) BOOL visited;
@property (assign, nonatomic) BOOL wallNorthHit;
@property (assign, nonatomic) BOOL wallWestHit;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

- (void)reset;

@end



