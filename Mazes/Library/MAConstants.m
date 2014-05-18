//
//  MAConstants.m
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAConstants.h"

NSString* const MAWebServicesIsLoggedInKeyPath = @"isLoggedIn";
NSString* const MASoundManagerCountKeyPath = @"count";
NSString* const MATextureManagerCountKeyPath = @"count";

NSString* const MAFlurryAPIKey = @"72C58XPN2XTXVRTP27BN";
NSString* const MACrashlyticsAPIKey = @"dcf833ce95eabb0f4910d0b63d678444f65e79d1";

NSTimeInterval const MAEventTimerIntervalSecs = 0.01;

NSString* const MAReachabilityHostname = @"www.google.com";

NSString* const MALocalBaseSSLURLString = @"https://localhost:8443/mazes";
NSString* const MARemoteBaseSSLURLString = @"https://muis.fatfractal.com/mazes";

NSString* const MAStatusCodeKey = @"MAStatusCodeKey";
NSUInteger const MAMazeNameExistsStatusCode = 450;

NSUInteger const MARandomPasswordLength = 4.0;

NSUInteger const MARowsMin = 3;
NSUInteger const MARowsMax = 15;
NSUInteger const MAColumnsMin = 3;
NSUInteger const MAColumnsMax = 15;

float const MAWallHeight = 1.0;
float const MAEyeHeight = 0.6;
float const MAWallWidth = 1.2;
float const MAWallDepth = 0.2;

NSUInteger const MATextureCount = 1000;

float const MAMovementDuration = 0.4;
float const MAStepDurationAvgStart = 1 / 60.0;
float const MAFakeMovementPrcnt = 0.2; // percent of movement before wall disappears

NSUInteger const MAMazeNameMaxLength = 50;
NSUInteger const MALocationMessageMaxLength = 250;

NSString* const MAUseTutorialKey = @"useTutorial";
NSString* const MAHasSelectedWallKey = @"hasSelectedWall";
NSString* const MAHasSelectedLocationKey = @"hasSelectedLocation";

NSString* const MAGreenTextureId = @"92A1B17C-5F19-4A6C-B70F-1C961A8A2FB5";
NSString* const MARedTextureId = @"E774E067-D4D4-44D6-BC8D-6999B9FFA76E";

NSString* const MAAlternatingBrickTextureId = @"03C76469-321E-4D2D-A69C-D413670866CC";
NSString* const MALightSwirlMarbleTextureId = @"E4293FC5-74B5-460C-BD28-D71E1DB225E3";
NSString* const MACreamyWhiteMarbleTextureId = @"91185953-544C-4D64-BEE5-F42F7778480E";

NSString* const MARequestDescriptionGeneric = @"communicate with the server";
NSString* const MARequestDescriptionSaveMaze = @"save the maze to the server";
NSString* const MARequestDescriptionDownloadTopMazesSummaries = @"download the list of mazes from the server";
NSString* const MARequestDescriptionSaveMazeRating = @"save the rating for maze %@ to the server";
NSString* const MARequestDescriptionDownloadUserMaze = @"download your maze from the server";
NSString* const MARequestDescriptionDownloadMaze = @"download the maze from the server";

NSString* const MARequestDescriptionSaveMazeProgress = @"save your game progress to the server";
NSString* const MARequestDescriptionSaveMazeProgressNoRetry = @"save your game progress to the server for maze %@";











