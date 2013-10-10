//
//  MATextureManager.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMFatFractal/AMFatFractal.h>

@class MATexture;

typedef void (^TexturesDownloadCompletionHandler)();

@interface MATextureManager : NSObject

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal;

- (void)downloadWithCompletionHandler: (TexturesDownloadCompletionHandler)handler;
- (void)cancelDownload;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (MATexture *)textureWithTextureId: (NSString *)textureId;

@end
