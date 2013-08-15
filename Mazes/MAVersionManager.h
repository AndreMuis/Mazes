//
//  MAVersionManager.h
//  Mazes
//
//  Created by Andre Muis on 7/27/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAVersion;

typedef void (^VersionDownloadCompletionHandler)(MAVersion *version);

@interface MAVersionManager : NSObject

@property (strong, nonatomic) MAVersion *version;

+ (MAVersionManager *)shared;

- (void)downloadWithCompletionHandler: (VersionDownloadCompletionHandler)handler;

- (void)cancelDownload;

@end
