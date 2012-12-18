//
//  Textures.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebServices.h"

@class Texture;

@interface Textures : NSObject <MAWebServicesGetTexturesDelegate>
{
    WebServices *webServices;
}

@property (assign, nonatomic, readonly) BOOL loaded;
@property (assign, nonatomic, readonly) int count;
@property (assign, nonatomic, readonly) int maxId;

+ (Textures *)shared;

- (void)load;

- (NSArray *)getTextures;

- (NSArray *)getTexturesSorted;

- (Texture *)getTextureWithId: (int)textureId;

@end
