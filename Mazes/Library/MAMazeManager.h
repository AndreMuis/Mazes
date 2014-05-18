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
	MATopMazeSummariesUnknown = 0,
	MATopMazeSummariesHighestRated = 1,
	MATopMazeSummariesNewest = 2,
	MATopMazeSummariesYours = 3
} MATopMazeSummariesType;

typedef void (^DownloadTopMazeSummariesCompletionHandler)(NSError *error);

@interface MAMazeManager : NSObject

@property (readonly, strong, nonatomic) MAMaze *firstUserMaze;
@property (readwrite, assign, nonatomic) BOOL isFirstUserMazeSizeChosen;

- (id)initWithWebServices: (MAWebServices *)webServices;

- (NSArray *)allUserMazes;
- (void)addMaze: (MAMaze *)maze;

- (void)downloadTopMazeSummariesWithType: (MATopMazeSummariesType)topMazeSummariesType
                       completionHandler: (DownloadTopMazeSummariesCompletionHandler)completionHandler;

- (BOOL)isDownloadingTopMazeSummariesOfType: (MATopMazeSummariesType)topMazeSummariesType;

- (NSArray *)topMazeSummariesOfType: (MATopMazeSummariesType)topMazeSummariesType;

@end
















