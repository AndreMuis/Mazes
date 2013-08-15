//
//  MAConstants.h
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int
{
	MADirectionUnknown = 0,
	MADirectionNorth = 1,
	MADirectionEast = 2,
	MADirectionSouth = 3,
	MADirectionWest = 4
} MADirectionType;

@interface MAConstants : NSObject

@property (strong, nonatomic) NSString *flurryAPIKey;

@property (strong, nonatomic) NSString *crittercismAppId;

@property (strong, nonatomic) NSString *parseApplicationId;
@property (strong, nonatomic) NSString *parseClientKey;

@property (assign, nonatomic) NSTimeInterval eventTimerIntervalSecs;

@property (strong, nonatomic) NSURL *serverBaseURL;
@property (assign, nonatomic) NSTimeInterval serverRetryDelaySecs;

@property (assign, nonatomic) float receiveResponseTimeoutSecs;

@property (assign, nonatomic) int rowsMin;
@property (assign, nonatomic) int rowsMax;
@property (assign, nonatomic) int columnsMin;
@property (assign, nonatomic) int columnsMax;

@property (assign, nonatomic) float wallHeight;
@property (assign, nonatomic) float eyeHeight;
@property (assign, nonatomic) float wallWidth;
@property (assign, nonatomic) float wallDepth;

@property (assign, nonatomic) int textureCount;

@property (assign, nonatomic) float movementDuration;
@property (assign, nonatomic) float stepDurationAvgStart;
@property (assign, nonatomic) float fakeMovementPrcnt;

@property (assign, nonatomic) int locationMessageMaxLength;
@property (assign, nonatomic) int mazeNameMaxLength;
@property (assign, nonatomic) int nameExists;

@property (assign, nonatomic) int defaultWallTextureId;
@property (assign, nonatomic) int defaultFloorTextureId;
@property (assign, nonatomic) int defaultCeilingTextureId;

+ (MAConstants *)shared;

@end
