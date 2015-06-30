//
//  MARatingView.h
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARatingView : UIView

+ (instancetype)ratingView;

- (void)setupWithRating: (float)rating
              starColor: (UIColor *)starColor
           outlineWidth: (float)outlineWidth;

@end
