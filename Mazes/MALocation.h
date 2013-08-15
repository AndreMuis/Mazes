//
//  MALocation.h
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

#import "MAConstants.h"

@class MAMaze;
@class MATexture;

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

@interface MALocation : PFObject <PFSubclassing>

@property (assign, nonatomic) MAMaze *maze;
@property (assign, nonatomic) int xx;
@property (assign, nonatomic) int yy;
@property (assign, nonatomic) int direction;
@property (assign, nonatomic) MAWallType wallNorth;
@property (assign, nonatomic) MAWallType wallWest;
@property (assign, nonatomic) MALocationActionType action;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) int teleportId;
@property (assign, nonatomic) int teleportX;
@property (assign, nonatomic) int teleportY;
@property (assign, nonatomic) MATexture *wallNorthTexture;
@property (assign, nonatomic) MATexture *wallWestTexture;
@property (assign, nonatomic) MATexture *floorTexture;
@property (assign, nonatomic) MATexture *ceilingTexture;
@property (assign, nonatomic) BOOL visited;
@property (assign, nonatomic) BOOL wallNorthHit;
@property (assign, nonatomic) BOOL wallWestHit;

+ (NSString *)parseClassName;

- (void)reset;

@end
















