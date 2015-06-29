//
//  MAConstants.m
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAConstants.h"

NSString* const MACrashlyticsAPIKey = @"dcf833ce95eabb0f4910d0b63d678444f65e79d1";

NSTimeInterval const MAEventTimerIntervalSecs = 0.01;

NSUInteger const MACanvasRowsMin = 2;
NSUInteger const MACanvasRowsMax = 15;
NSUInteger const MACanvasColumnsMin = 2;
NSUInteger const MACanvasColumnsMax = 15;

float const MAWallHeight = 1.0;
float const MAEyeHeight = 0.6;
float const MAWallWidth = 1.2;
float const MAWallDepth = 0.2;

NSUInteger const MAMazeNameMaxLength = 50;
NSUInteger const MALocationMessageMaxLength = 250;

NSString* const MAUseTutorialKey = @"useTutorial";
NSString* const MAHasSelectedWallKey = @"hasSelectedWall";
NSString* const MAHasSelectedLocationKey = @"hasSelectedLocation";

NSString* const MARequestDescriptionGeneric = @"communicate with the server";
NSString* const MARequestDescriptionDownloadMaze = @"download the maze from the server";
NSString* const MARequestDescriptionDownloadUserMaze = @"download your maze from the server";
NSString* const MARequestDescriptionSaveMaze = @"save the maze to the server";
NSString* const MARequestDescriptionDownloadTopMazesSummaries = @"download the list of mazes from the server";
NSString* const MARequestDescriptionDownloadMazeCompletionCount = @"retrieve the number of mazes you have completed from the server to send to Game Center";
NSString* const MARequestDescriptionReportMazeCompletionCount = @"send the number of mazes you have completed to Game Center";
NSString* const MARequestDescriptionSaveMazeRating = @"save the rating for maze %@ to the server";





























