//
//  MAMazeManager.h
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMFatFractal/AMFatFractal.h>

@class MAMaze;
@class MASound;
@class MAStyles;
@class MATextureManager;
@class MATexture;

typedef void (^DownloadMazesCompletionHandler)();
typedef void (^SaveMazeCompletionHandler)();

@interface MAMazeManager : NSObject

@property (readwrite, strong, nonatomic) FFUser *currentUser;

@property (readonly, strong, nonatomic) MAMaze *firstUserMaze;
@property (readwrite, assign, nonatomic) BOOL isFirstUserMazeSizeChosen;

@property (readonly, strong, nonatomic) NSArray *highestRatedTopMazeItems;
@property (readonly, strong, nonatomic) NSArray *newestTopMazeItems;
@property (readonly, strong, nonatomic) NSArray *yoursTopMazeItems;

@property (readonly, assign, nonatomic) BOOL isDownloadingHighestRatedMazes;
@property (readonly, assign, nonatomic) BOOL isDownloadingNewestMazes;
@property (readonly, assign, nonatomic) BOOL isDownloadingYoursMazes;

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal;

- (NSArray *)allUserMazes;
- (void)addMaze: (MAMaze *)maze;

- (void)getUserMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler;
- (void)cancelGetUserMazes;

- (void)saveMaze: (MAMaze *)maze completionHandler: (SaveMazeCompletionHandler)handler;
- (void)cancelSaveMaze;

- (void)getHighestRatedMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler;
- (void)getNewestMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler;
- (void)getYoursMazesWithCompletionHandler: (DownloadMazesCompletionHandler)handler;

- (void)cancelDownloads;

@end
