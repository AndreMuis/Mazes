//
//  MAConstants.h
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
	MADirectionUnknown = 0,
	MADirectionNorth = 1,
	MADirectionEast = 2,
	MADirectionSouth = 3,
	MADirectionWest = 4
} MADirectionType;

extern NSString* const MAWebServicesIsLoggedInKeyPath;
extern NSString* const MASoundManagerCountKeyPath;
extern NSString* const MATextureManagerCountKeyPath;

extern NSString* const MAFlurryAPIKey;
extern NSString* const MACrittercismAppId;

extern NSTimeInterval const MAEventTimerIntervalSecs;

extern NSString* const MAReachabilityHostname;

extern NSString* const MALocalBaseSSLURLString;
extern NSString* const MARemoteBaseSSLURLString;

extern NSString* const MAStatusCodeKey;
extern NSUInteger const MAMazeNameExistsStatusCode;

extern NSUInteger const MARandomPasswordLength;

extern int const MARowsMin;
extern int const MARowsMax;
extern int const MAColumnsMin;
extern int const MAColumnsMax;

extern float const MAWallHeight;
extern float const MAEyeHeight;
extern float const MAWallWidth;
extern float const MAWallDepth;

extern int const MATextureCount;

extern float const MAMovementDuration;
extern float const MAStepDurationAvgStart;
extern float const MAFakeMovementPrcnt;

extern int const MALocationMessageMaxLength;
extern int const MAMazeNameMaxLength;

extern NSString* const MAGreenTextureId;
extern NSString* const MARedTextureId;

extern NSString* const MAUseTutorialKey;
extern NSString* const MAHasSelectedWallKey;
extern NSString* const MAHasSelectedLocationKey;

extern NSString* const MAAlternatingBrickTextureId;
extern NSString* const MALightSwirlMarbleTextureId;
extern NSString* const MACreamyWhiteMarbleTextureId;

extern NSString* const MANoInternetMessage;
extern NSString* const MARequestErrorMessage;
extern NSString* const MADownloadTopMazesSummariesErrorMessage;
extern NSString* const MASaveMazeRatingErrorMessage;
extern NSString* const MADownloadUserMazeErrorMessage;
extern NSString* const MADownloadMazeErrorMessage;
extern NSString* const MASaveMazeStartedErrorMessage;

























