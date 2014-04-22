//
//  MASoundManager.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAWebServices;

typedef void (^DownloadSoundsCompletionHandler)(NSError *error);

@interface MASoundManager : NSObject

@property (assign, nonatomic, readonly) NSUInteger count;

+ (id)soundManagerWithWebServices: (MAWebServices *)webServices;

- (id)initWithWebServices: (MAWebServices *)webServices;

- (void)downloadSoundsWithCompletionHandler: (DownloadSoundsCompletionHandler)handler;

- (NSArray *)sortedByName;

@end
