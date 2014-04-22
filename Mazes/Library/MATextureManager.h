//
//  MATextureManager.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAWebServices;
@class MATexture;

typedef void (^DownloadTexturesCompletionHandler)(NSError *error);

@interface MATextureManager : NSObject

@property (assign, nonatomic, readonly) NSUInteger count;

+ (MATextureManager *)textureManagerWithWebServices: (MAWebServices *)webServices;

- (id)initWithWithWebServices: (MAWebServices *)webServices;

- (void)downloadTexturesWithCompletionHandler: (DownloadTexturesCompletionHandler)handler;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (MATexture *)textureWithTextureId: (NSString *)textureId;

@end
