//
//  Constants.h
//  iPad_Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEF_NORTH 1
#define DEF_EAST 2
#define DEF_SOUTH 3
#define DEF_WEST 4

#define TEXTURES 1000

typedef struct
{
	int DoNothing;
	int DisplayAvg;
	int DisplayUser;
	int RecordPopover;
	int RecordEnd;
} RatingModeType;

typedef struct
{
	int North;
	int East;
	int South;
	int West;
} DirectionType;

typedef struct
{
	int Location;
	int WallNorth;
	int WallWest;
	int Corner;
} MazeObjectType;

typedef struct
{
	int DoNothing;
	int Start;
	int End;
	int StartOver;
	int Teleportation;
} LocationTypeType;

typedef struct
{
	int None;
	int Solid;
	int Invisible;
	int Fake;
} WallTypeType;

typedef struct
{
	int Backward;
	int Forward;
	int TurnLeft;
	int TurnRight;
} MovementType;

@interface Constants : NSObject 
{
    float receiveResponseTimeoutSecs;
    
	DirectionType Direction;
	
	MazeObjectType MazeObject;
	
	LocationTypeType LocationType;
	
	WallTypeType WallType;
	
	MovementType Movement;
	
	RatingModeType RatingMode;

    int rowsMin;
    int rowsMax;
    int columnsMin;
    int columnsMax;
    
    float wallHeight;
    float eyeHeight;
    float wallWidth;
    float wallDepth;
    
    float movementDuration;
    float stepDurationAvgStart;
    float fakeMovementPrcnt;
    
    int locationMessageMaxLength;
    int mazeNameMaxLength;
    int nameExists;
}

@property (strong, nonatomic, readonly) NSString *flurryAPIKey;

@property (strong, nonatomic, readonly) NSString *crittercismAppId;

@property (strong, nonatomic, readonly) NSURL *serverBaseURL;
@property (assign, nonatomic, readonly) NSTimeInterval serverRetryDelaySecs;

@property (nonatomic) float receiveResponseTimeoutSecs;

@property (nonatomic) DirectionType Direction;

@property (nonatomic) MazeObjectType MazeObject;

@property (nonatomic) LocationTypeType LocationType;

@property (nonatomic) WallTypeType WallType;

@property (nonatomic) MovementType Movement;

@property (nonatomic) RatingModeType RatingMode;

@property (nonatomic) int rowsMin;
@property (nonatomic) int rowsMax;
@property (nonatomic) int columnsMin;
@property (nonatomic) int columnsMax;

@property (nonatomic) float wallHeight;
@property (nonatomic) float eyeHeight;
@property (nonatomic) float wallWidth;
@property (nonatomic) float wallDepth;

@property (nonatomic) float movementDuration;
@property (nonatomic) float stepDurationAvgStart;
@property (nonatomic) float fakeMovementPrcnt;

@property (nonatomic) int locationMessageMaxLength;
@property (nonatomic) int mazeNameMaxLength;
@property (nonatomic) int nameExists;

+ (Constants *)shared;

@end
