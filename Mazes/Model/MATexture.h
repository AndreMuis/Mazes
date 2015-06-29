//
//  MATexture.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MATexture : NSObject

@property (readonly, strong, nonatomic) NSString *textureId;
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, assign, nonatomic) NSUInteger kind;
@property (readonly, assign, nonatomic) NSUInteger order;

@end
