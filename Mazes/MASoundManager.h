//
//  MASoundManager.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMFatFractal/AMFatFractal.h>

@class MASound;

typedef void (^SoundsDownloadCompletionHandler)();

@interface MASoundManager : NSObject

@property (assign, nonatomic, readonly) int count;

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal;

- (void)downloadWithCompletionHandler: (SoundsDownloadCompletionHandler)handler;
- (void)cancelDownload;

- (NSArray *)sortedByName;

@end
