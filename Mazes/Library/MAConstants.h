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

extern NSString* const MAMazeRowsKeyPath;
extern NSString* const MAMazeColumnsKeyPath;

extern NSString* const MAMazeLocationsKeyPath;
extern NSString* const MAMazeWallsKeyPath;

extern NSString* const MALocationActionKeyPath;
extern NSString* const MALocationDirectionKeyPath;
extern NSString* const MALocationFloorTextureIdKeyPath;
extern NSString* const MALocationCeilingTextureIdKeyPath;

extern NSString* const MAWallTypeKeyPath;
extern NSString* const MAWallTextureIdKeyPath;

extern NSString* const MAFlurryAPIKey;
extern NSString* const MACrashlyticsAPIKey;

extern NSTimeInterval const MAEventTimerIntervalSecs;

extern NSString* const MAReachabilityHostname;

extern NSString* const MALocalBaseSSLURLString;
extern NSString* const MARemoteBaseSSLURLString;

extern NSString* const MAStatusCodeKey;
extern NSUInteger const MAMazeNameExistsStatusCode;

extern NSUInteger const MARandomPasswordLength;

extern NSUInteger const MARowsMin;
extern NSUInteger const MARowsMax;
extern NSUInteger const MAColumnsMin;
extern NSUInteger const MAColumnsMax;

extern float const MAWallHeight;
extern float const MAEyeHeight;
extern float const MAWallWidth;
extern float const MAWallDepth;

extern NSUInteger const MATextureCount;

extern float const MAMovementDuration;
extern float const MAStepDurationAvgStart;
extern float const MAFakeMovementPrcnt;

extern NSUInteger const MAMazeNameMaxLength;
extern NSUInteger const MALocationMessageMaxLength;

extern NSString* const MAUseTutorialKey;
extern NSString* const MAHasSelectedWallKey;
extern NSString* const MAHasSelectedLocationKey;

extern NSString* const MAGreenTextureId;
extern NSString* const MARedTextureId;

extern NSString* const MAAlternatingBrickTextureId;
extern NSString* const MALightSwirlMarbleTextureId;
extern NSString* const MACreamyWhiteMarbleTextureId;

extern NSString* const MARequestDescriptionGeneric;
extern NSString* const MARequestDescriptionDownloadMaze;
extern NSString* const MARequestDescriptionDownloadUserMaze;
extern NSString* const MARequestDescriptionSaveMaze;
extern NSString* const MARequestDescriptionDownloadTopMazesSummaries;
extern NSString* const MARequestDescriptionDownloadMazeCompletionCount;
extern NSString* const MARequestDescriptionReportMazeCompletionCount;
extern NSString* const MARequestDescriptionSaveMazeRating;

extern NSString* const MARequestDescriptionSaveMazeProgress;
extern NSString* const MARequestDescriptionSaveMazeProgressNoRetry;


































