//
//  MATextureManager.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Reachability/Reachability.h>

@class MAWebServices;
@class MATexture;

@interface MATextureManager : NSObject

@property (assign, nonatomic, readonly) NSUInteger count;

+ (MATextureManager *)textureManagerWithReachability: (Reachability *)reachability
                                         webServices: (MAWebServices *)webServices;

- (id)initWithWithReachability: (Reachability *)reachability
                   webServices: (MAWebServices *)webServices;

- (void)downloadTextures;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (MATexture *)textureWithTextureId: (NSString *)textureId;

@end
