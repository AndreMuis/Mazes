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
NSString* const MACrittercismAppId = @"50cbd3ed4f633a03f0000003";

NSTimeInterval const MAEventTimerIntervalSecs = 0.01;

NSString* const MAReachabilityHostname = @"www.google.com";

NSString* const MALocalBaseSSLURLString = @"https://localhost:8443/mazes";
NSString* const MARemoteBaseSSLURLString = @"https://muis.fatfractal.com/mazes";

NSString* const MAStatusCodeKey = @"MAStatusCodeKey";
NSUInteger const MAMazeNameExistsStatusCode = 450;

NSUInteger const MARandomPasswordLength = 4.0;

int const MARowsMin = 3;
int const MARowsMax = 15;
int const MAColumnsMin = 3;
int const MAColumnsMax = 15;

float const MAWallHeight = 1.0;
float const MAEyeHeight = 0.6;
float const MAWallWidth = 1.2;
float const MAWallDepth = 0.2;

int const MATextureCount = 1000;

float const MAMovementDuration = 0.4;
float const MAStepDurationAvgStart = 1 / 60.0;
float const MAFakeMovementPrcnt = 0.2; // percent of movement before wall disappears

int const MALocationMessageMaxLength = 250;
int const MAMazeNameMaxLength = 50;

NSString* const MAUseTutorialKey = @"useTutorial";
NSString* const MAHasSelectedWallKey = @"hasSelectedWall";
NSString* const MAHasSelectedLocationKey = @"hasSelectedLocation";

NSString* const MAGreenTextureId = @"92A1B17C-5F19-4A6C-B70F-1C961A8A2FB5";
NSString* const MARedTextureId = @"E774E067-D4D4-44D6-BC8D-6999B9FFA76E";

NSString* const MAAlternatingBrickTextureId = @"03C76469-321E-4D2D-A69C-D413670866CC";
NSString* const MALightSwirlMarbleTextureId = @"E4293FC5-74B5-460C-BD28-D71E1DB225E3";
NSString* const MACreamyWhiteMarbleTextureId = @"91185953-544C-4D64-BEE5-F42F7778480E";

NSString* const MANoInternetMessage = @"This device is not connected to the internet."
    "This app needs an internet connection to run. Please connect if possible.";

NSString* const MARequestErrorMessage = @"A problem occured while trying to communicate with the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MASaveMazeErrorMessage = @"A problem occured while trying to save the maze to the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MADownloadTopMazesSummariesErrorMessage = @"A problem occured while trying to download the list of mazes from the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MASaveMazeRatingErrorMessage = @"A problem occured while trying to save the maze rating to the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MADownloadUserMazeErrorMessage = @"A problem occured while trying to download your maze from the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MADownloadMazeErrorMessage = @"A problem occured while trying to download the maze from the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MASaveMazeProgressErrorMessage = @"A problem occured while trying to save your game progress to the server."
    "Please try again. If the problem persists an update should be available shortly.";

NSString* const MASaveMazeProgressNoRetryErrorMessage = @"A problem occured while trying to save your game progress to the server for maze %@."
    "If the problem persists an update should be available shortly.";











