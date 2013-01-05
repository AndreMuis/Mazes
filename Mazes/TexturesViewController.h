//
//  TexturesViewController.h
//  Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Styles.h"

@interface TexturesViewController : UIViewController 

@property (strong, nonatomic) id textureDelegate;
@property (assign, nonatomic) SEL textureSelector;
@property (strong, nonatomic) id exitDelegate;
@property (assign, nonatomic) SEL exitSelector;

- (void)setupScrollView;

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer; 

@end
