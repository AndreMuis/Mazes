//
//  MAMazeManager.h
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

typedef void (^DownloadCompletionHandler)();

@interface MAMazeManager : NSObject

@property (strong, nonatomic) NSArray *highestRatedTopMazeItems;
@property (strong, nonatomic) NSArray *newestTopMazeItems;
@property (strong, nonatomic) NSArray *yoursTopMazeItems;

@property (assign, nonatomic, readonly) BOOL isDownloadingHighestRatedMazes;
@property (assign, nonatomic, readonly) BOOL isDownloadingNewestMazes;
@property (assign, nonatomic, readonly) BOOL isDownloadingYoursMazes;

+ (MAMazeManager *)shared;

- (void)getHighestRatedMazesWithCompletionHandler: (DownloadCompletionHandler)handler;

- (void)getNewestMazesWithCompletionHandler: (DownloadCompletionHandler)handler;

- (void)getYoursMazesWithCompletionHandler: (DownloadCompletionHandler)handler;

@end
