//
//  MATexture.h
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MATexture : NSObject

@property (readwrite, strong, nonatomic) NSString *textureId;
@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, assign, nonatomic) int width;
@property (readwrite, assign, nonatomic) int height;
@property (readwrite, assign, nonatomic) int repeats;
@property (readwrite, assign, nonatomic) int kind;
@property (readwrite, assign, nonatomic) int order;

@end
