//
//  MARatingViewController.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MARatingView;
@class MAStyles;

@interface MARatingViewController : UIViewController

@property (readwrite,strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet MARatingView *ratingView;

@end
