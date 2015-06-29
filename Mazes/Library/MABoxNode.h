//
//  MABoxNode.h
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface MABoxNode : SCNNode

- (instancetype)initWithX: (CGFloat)x
                        y: (CGFloat)y
                        z: (CGFloat)z
                    width: (CGFloat)width
                   height: (CGFloat)height
                   length: (CGFloat)length
                    color: (UIColor *)color
                  opacity: (CGFloat)opacity;

@end
