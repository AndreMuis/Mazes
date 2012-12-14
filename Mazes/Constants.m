//
//  Constants.m
//  iPad_Mazes_2
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

@synthesize serverBaseURL;

@synthesize receiveResponseTimeoutSecs;
@synthesize serverRetryDelaySecs;

@synthesize Direction;
@synthesize MazeObject;
@synthesize LocationType; 
@synthesize WallType;
@synthesize Movement;
@synthesize RatingMode;

@synthesize rowsMin;
@synthesize rowsMax;
@synthesize columnsMin;
@synthesize columnsMax;

@synthesize wallHeight;
@synthesize eyeHeight;
@synthesize wallWidth;
@synthesize wallDepth;

@synthesize movementDuration;
@synthesize stepDurationAvgStart;
@synthesize fakeMovementPrcnt;

@synthesize locationMessageMaxLength;
@synthesize mazeNameMaxLength;
@synthesize nameExists;

+ (Constants *)shared
{
	static Constants *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Constants alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        #if defined DEBUG
            serverBaseURL = @"http://localhost:3000";
        #else
            serverBaseURL = @"http://173.45.249.212:3000";
        #endif

        serverRetryDelaySecs = 5.0;
        
        receiveResponseTimeoutSecs = 5.0;

		Direction.North = DEF_NORTH;
		Direction.East = DEF_EAST;
		Direction.South = DEF_SOUTH;
		Direction.West = DEF_WEST;
		
		MazeObject.Location = 1;
		MazeObject.WallNorth = 2;
		MazeObject.WallWest = 3;
		MazeObject.Corner = 4;
		
		LocationType.DoNothing = 0;
		LocationType.Start = 1;
		LocationType.End = 2;
		LocationType.StartOver = 3;
		LocationType.Teleportation = 4;
		
		WallType.None = 1;
		WallType.Solid = 2;
		WallType.Invisible = 3;
		WallType.Fake = 4;
		
		Movement.Backward = 1;
		Movement.Forward = 2;
		Movement.TurnLeft = 3;
		Movement.TurnRight = 4;
		
		RatingMode.DoNothing = 1;
		RatingMode.DisplayAvg = 2;
		RatingMode.DisplayUser = 3;
		RatingMode.RecordPopover = 4;
		RatingMode.RecordEnd = 5;
		
		rowsMin = 3;
		rowsMax = 15;
		columnsMin = rowsMin;
		columnsMax = rowsMax;
		
		wallHeight = 1.0;
		eyeHeight = 0.6 * wallHeight;
		wallWidth = 1.2;
		wallDepth = 0.2;		
		
		movementDuration = 0.4;
		stepDurationAvgStart = 1 / 60.0;
		fakeMovementPrcnt = 0.2; // percent of movement before wall disappears
		
		locationMessageMaxLength = 250;
		mazeNameMaxLength = 50;
		nameExists = -1;
	}
	
    return self;
}

@end
