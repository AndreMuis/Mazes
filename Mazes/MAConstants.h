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

@property (readonly, strong, nonatomic) NSString *flurryAPIKey;
@property (readonly, strong, nonatomic) NSString *crittercismAppId;

@property (readonly, assign, nonatomic) NSTimeInterval eventTimerIntervalSecs;

@property (readonly, strong, nonatomic) NSURL *localBaseSSLURL;
@property (readonly, strong, nonatomic) NSURL *remoteBaseSSLURL;

@property (readonly, strong, nonatomic) NSURL *baseSSLURL;

@property (readonly, assign, nonatomic) NSTimeInterval serverRetryDelaySecs;

@property (readonly, assign, nonatomic) NSUInteger randomPasswordLength;

@property (readonly, assign, nonatomic) int rowsMin;
@property (readonly, assign, nonatomic) int rowsMax;
@property (readonly, assign, nonatomic) int columnsMin;
@property (readonly, assign, nonatomic) int columnsMax;

@property (readonly, assign, nonatomic) float wallHeight;
@property (readonly, assign, nonatomic) float eyeHeight;
@property (readonly, assign, nonatomic) float wallWidth;
@property (readonly, assign, nonatomic) float wallDepth;

@property (readonly, assign, nonatomic) int textureCount;

@property (readonly, assign, nonatomic) float movementDuration;
@property (readonly, assign, nonatomic) float stepDurationAvgStart;
@property (readonly, assign, nonatomic) float fakeMovementPrcnt;

@property (readonly, assign, nonatomic) int locationMessageMaxLength;
@property (readonly, assign, nonatomic) int mazeNameMaxLength;
@property (readonly, assign, nonatomic) int nameExists;

@property (readonly, strong, nonatomic) NSString *greenTextureId;
@property (readonly, strong, nonatomic) NSString *redTextureId;

@property (readonly, strong, nonatomic) NSString *alternatingBrickTextureId;
@property (readonly, strong, nonatomic) NSString *lightSwirlMarbleTextureId;
@property (readonly, strong, nonatomic) NSString *creamyWhiteMarbleTextureId;

@end


























