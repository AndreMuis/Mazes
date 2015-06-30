//
//  MAConstants.h
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MADirectionType)
{
    MADirectionUnknown = 0,
    MADirectionNorth = 1,
    MADirectionEast = 2,
    MADirectionSouth = 3,
    MADirectionWest = 4
};

typedef NS_ENUM(NSUInteger, MAWallPositionType)
{
    MAWallPositionUnknown = 0,
    MAWallPositionLeft = 1,
    MAWallPositionTop = 2
};

typedef NS_ENUM(NSUInteger, MASegmentType)
{
    MASegmentTypeUnknown = 0,
    MASegmentTypeHighestRated = 1,
    MASegmentTypeNewest = 2
};

extern NSString* const MACrashlyticsAPIKey;

extern NSTimeInterval const MAEventTimerIntervalSecs;

extern float const MAWallHeight;
extern float const MAEyeHeight;
extern float const MAWallWidth;
extern float const MAWallDepth;

extern float const MSStarCuspRadiusAsPercentOfTipRadius;

extern NSUInteger const MAMazeNameMaxLength;
extern NSUInteger const MALocationMessageMaxLength;

extern NSString* const MAUseTutorialKey;
extern NSString* const MAHasSelectedWallKey;
extern NSString* const MAHasSelectedLocationKey;

extern NSString* const MARequestDescriptionGeneric;
extern NSString* const MARequestDescriptionDownloadMaze;
extern NSString* const MARequestDescriptionDownloadUserMaze;
extern NSString* const MARequestDescriptionSaveMaze;
extern NSString* const MARequestDescriptionDownloadTopMazesSummaries;
extern NSString* const MARequestDescriptionDownloadMazeCompletionCount;
extern NSString* const MARequestDescriptionReportMazeCompletionCount;
extern NSString* const MARequestDescriptionSaveMazeRating;



































