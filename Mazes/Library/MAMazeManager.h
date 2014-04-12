//
//  MAMazeManager.h
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAMaze;
@class MASound;
@class MAStyles;
@class MATextureManager;
@class MATexture;
@class MAWebServices;

typedef enum : NSUInteger
{
	MATopMazesUnknown = 0,
	MATopMazesHighestRated = 1,
	MATopMazesNewest = 2,
	MATopMazesYours = 3
} MATopMazesType;

typedef void (^DownloadTopMazeSummariesCompletionHandler)(NSError *error);

@interface MAMazeManager : NSObject

@property (readonly, strong, nonatomic) MAMaze *maze;

@property (readonly, strong, nonatomic) MAMaze *firstUserMaze;
@property (readwrite, assign, nonatomic) BOOL isFirstUserMazeSizeChosen;

- (id)initWithWebServices: (MAWebServices *)webServices;

- (NSArray *)allUserMazes;
- (void)addMaze: (MAMaze *)maze;

- (void)downloadTopMazeSummariesWithType: (MATopMazesType)topMazesType
                       completionHandler: (DownloadTopMazeSummariesCompletionHandler)completionHandler;

- (NSArray *)topMazeSummariesOfType: (MATopMazesType)topMazesType;

@end
















