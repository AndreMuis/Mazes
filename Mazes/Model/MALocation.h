//
//  MALocation.h
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAConstants.h"
#import "MACoordinate.h"

@class MAMaze;
@class MATextureManager;
@class MATexture;

typedef enum : int
{
	MALocationActionUnknown = 0,
	MALocationActionDoNothing = 1,
	MALocationActionStart = 2,
	MALocationActionEnd = 3,
	MALocationActionStartOver = 4,
	MALocationActionTeleport = 5
} MALocationActionType;

@interface MALocation : NSObject <NSCoding>

@property (readwrite, strong, nonatomic) NSString *locationId;
@property (readwrite, strong, nonatomic) MACoordinate *coordinate;
@property (readwrite, assign, nonatomic) int direction;
@property (readwrite, assign, nonatomic) MALocationActionType action;
@property (readwrite, strong, nonatomic) NSString *message;
@property (readwrite, assign, nonatomic) int teleportId;
@property (readwrite, assign, nonatomic) int teleportX;
@property (readwrite, assign, nonatomic) int teleportY;
@property (readwrite, strong, nonatomic) NSString *floorTextureId;
@property (readwrite, strong, nonatomic) NSString *ceilingTextureId;

@property (readonly, assign, nonatomic) NSUInteger row;
@property (readonly, assign, nonatomic) NSUInteger column;

@property (readwrite, assign, nonatomic) BOOL visited;

@property (readwrite, assign, nonatomic) CGRect mapRect;
@property (readwrite, strong, nonatomic) UIColor *mapColor;

// top-left corner
@property (readwrite, assign, nonatomic) CGRect mapCornerRect;
@property (readwrite, strong, nonatomic) UIColor *mapCornerColor;

- (void)reset;

@end
















