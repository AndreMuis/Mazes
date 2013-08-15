//
//  MATextureManager.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MATexture;

typedef void (^TexturesDownloadCompletionHandler)();

@interface MATextureManager : NSObject

@property (assign, nonatomic, readonly) int count;
@property (assign, nonatomic, readonly) int maxGLId;

+ (MATextureManager *)shared;

- (void)downloadWithCompletionHandler: (TexturesDownloadCompletionHandler)handler;
- (void)cancelDownload;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (MATexture *)textureWithObjectId: (NSString *)objectId;

@end
