//
//  MATextureManager.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MATexture;

@interface MATextureManager : NSObject

@property (assign, nonatomic, readonly) int count;

- (id)initWithTextures: (NSArray *)textures;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (MATexture *)textureWithTextureId: (NSString *)textureId;

@end
