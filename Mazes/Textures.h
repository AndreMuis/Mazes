//
//  Textures.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"

#import "ServerOperations.h"

@class Texture;

@interface Textures : NSObject <MAServerOperationsGetTexturesDelegate>

@property (assign, nonatomic) int count;
@property (assign, nonatomic) int maxId;

+ (Textures *)shared;

- (void)download;

- (NSArray *)all;

- (NSArray *)sortedByKindThenOrder;

- (Texture *)textureWithId: (int)textureId;

@end
