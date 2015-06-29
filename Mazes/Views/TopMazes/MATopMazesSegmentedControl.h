//
//  MATopMazesSegmentedControl.h
//  Mazes
//
//  Created by Andre Muis on 6/27/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"

@interface MATopMazesSegmentedControl : UIControl

@property (readonly, assign, nonatomic) MASegmentType selectedSegmentType;

+ (instancetype)topMazesSegmentedControl;

- (void)addToParentView: (UIView *)parentView;

@end
