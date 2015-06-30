//
//  MAStarView.h
//  Mazes
//
//  Created by Andre Muis on 6/29/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAStarViewDelegate;

@interface MAStarView : UIView

- (void)setupWithDelegate: (id<MAStarViewDelegate>)delegate
                    color: (UIColor *)color
              fillPercent: (CGFloat)fillPercent
             outlineWidth: (CGFloat)outlineWidth;

@end
