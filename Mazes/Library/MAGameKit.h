//
//  MAGameKit.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol MAGameKitDelegate;

typedef void (^DownloadMazeCompletionCountCompletionHandler)(NSError *error);
typedef void (^ReportMazeCompletionCountCompletionHandler)(NSError *error);

@interface MAGameKit : NSObject

@property (readonly, assign, nonatomic) BOOL isLocalPlayerAuthenticateHandlerSetup;
@property (readonly, assign, nonatomic) BOOL isLocalPlayerAuthenticated;

@property (readonly, assign, nonatomic) BOOL isReportingMazeCompletionCount;

+ (MAGameKit *)gameKit;

+ (MAGameKit *)gameKitWithDelegate: (id<MAGameKitDelegate>)delegate;

- (instancetype)initWithDelegate: (id<MAGameKitDelegate>)delegate;

- (void)setupAuthenticateHandler;

- (void)downloadMazeCompletionCountWithCompletion: (DownloadMazeCompletionCountCompletionHandler)handler;
- (void)reportMazeCompletionCountWithCompletion: (ReportMazeCompletionCountCompletionHandler)handler;

- (void)displayLeaderboardWithPresentingViewController: (UIViewController *)presentingViewController;

@end
