//
//  MABoxNode.m
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MABoxNode.h"

@implementation MABoxNode

- (instancetype)initWithX: (CGFloat)x
                        y: (CGFloat)y
                        z: (CGFloat)z
                    width: (CGFloat)width
                   height: (CGFloat)height
                   length: (CGFloat)length
                    color: (UIColor *)color
                  opacity: (CGFloat)opacity
{
    self = [super init];
    
    if (self)
    {
        SCNBox *box = [SCNBox boxWithWidth: width
                                    height: height
                                    length: length
                             chamferRadius: 0.0];
        
        box.firstMaterial.diffuse.contents = color;
        box.firstMaterial.specular.contents = color;
        
        self.geometry = box;
        self.opacity = opacity;
        
        self.position = SCNVector3Make(x + width / 2.0,
                                       y + height / 2.0,
                                       z + length / 2.0);
    }

    return self;
}

@end











