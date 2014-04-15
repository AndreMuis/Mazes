//
//  MATexturesViewController.h
//  Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MATextureManager;
@class MATexture;

typedef void (^TextureSelectedHandler)(MATexture *texture);

@interface MATexturesViewController : UIViewController 

@property (readwrite, strong, nonatomic) TextureSelectedHandler textureSelectedHandler;

- (id)initWithTextureManager: (MATextureManager *)textureManager;

- (void)setup;

@end
