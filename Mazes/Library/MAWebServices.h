//
//  MAWebServices.h
//  Mazes
//
//  Created by Andre Muis on 12/26/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FFEF/FatFractal.h>
#import <Reachability/Reachability.h>

@class MALatestVersion;
@class MAMaze;
@class MAUserCounter;

typedef void (^AutoLoginCompletionHandler)(NSError *error);
typedef void (^GetUserCounterCompletionHandler)(MAUserCounter *userCounter, NSError *error);
typedef void (^LoginCompletionHandler)(NSError *error);

typedef void (^GetTexturesCompletionHandler)(NSArray *textures, NSError *error);
typedef void (^GetSoundsCompletionHandler)(NSArray *sounds, NSError *error);

typedef void (^GetUserMazesCompletionHandler)(NSArray *userMazes, NSError *error);
typedef void (^GetMazeCompletionHandler)(MAMaze *maze, NSError *error);

typedef void (^SaveMazeCompletionHandler)(NSError *error);

typedef void (^GetTopMazeSummariesCompletionHandler)(NSArray *topMazeSummaries, NSError *error);

typedef void (^SaveStartedCompletionHandler)(NSString *mazeId, NSError *error);
typedef void (^SaveFoundExitCompletionHandler)(NSString *mazeId, NSString *mazeName, NSError *error);

typedef void (^SaveRatingCompletionHandler)(NSError *error);

typedef void (^GetLatestVersionCompletionHandler)(MALatestVersion *latestVersion, NSError *error);

@interface MAWebServices : NSObject

@property (readonly, strong, nonatomic) id<FFUserProtocol> loggedInUser;
@property (readonly, assign, nonatomic) BOOL isLoggedIn;
@property (readonly, assign, nonatomic) BOOL isLoggingIn;

@property (readonly, assign, nonatomic) BOOL isDownloadingUserMazes;

@property (readonly, assign, nonatomic) BOOL isSavingMaze;

@property (readonly, assign, nonatomic) BOOL isDownloadingHighestRatedMazeSummaries;
@property (readonly, assign, nonatomic) BOOL isDownloadingNewestMazeSummaries;
@property (readonly, assign, nonatomic) BOOL isDownloadingYoursMazeSummaries;

- (id)initWithReachability: (Reachability *)reachability;

- (void)autologinWithCompletionHandler: (AutoLoginCompletionHandler)handler;

- (void)getTexturesWithCompletionHandler: (GetTexturesCompletionHandler)handler;
- (void)getSoundsWithCompletionHandler: (GetSoundsCompletionHandler)handler;

- (void)getUserMazesWithCompletionHandler: (GetUserMazesCompletionHandler)handler;
- (void)getMazeWithMazeId: (NSString *)mazeId completionHandler: (GetMazeCompletionHandler)handler;

- (void)saveMaze: (MAMaze *)maze completionHandler: (SaveMazeCompletionHandler)handler;

- (void)getHighestRatedMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler;
- (void)getNewestMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler;
- (void)getYoursMazeSummariesWithCompletionHandler: (GetTopMazeSummariesCompletionHandler)handler;

- (void)saveStartedWithUserName: (NSString *)userName mazeId: (NSString *)mazeId completionHandler: (SaveStartedCompletionHandler)handler;
- (void)saveFoundExitWithUserName: (NSString *)userName mazeId: (NSString *)mazeId mazeName: (NSString *)mazeName completionHandler: (SaveFoundExitCompletionHandler)handler;
- (void)saveMazeRatingWithUserName: (NSString *)userName mazeId: (NSString *)mazeId rating: (float)rating completionHandler: (SaveRatingCompletionHandler)handler;

- (void)getLatestVersionWithCompletionHandler: (GetLatestVersionCompletionHandler)handler;

@end


















