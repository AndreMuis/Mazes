//
//  MASoundManager.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASound;

typedef void (^SoundsDownloadCompletionHandler)();

@interface MASoundManager : NSObject

@property (assign, nonatomic, readonly) int count;

+ (MASoundManager *)shared;

- (void)downloadWithCompletionHandler: (SoundsDownloadCompletionHandler)handler;

- (void)cancelDownload;

- (NSArray *)sortedByName;

- (MASound *)soundWithObjectId: (NSString *)objectId;

@end
