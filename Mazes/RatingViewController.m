//
//  RatingViewController.m
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "RatingViewController.h"

#import "RatingView.h"
#import "RatingViewStyle.h"
#import "Styles.h"

@implementation RatingViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [Styles shared].ratingView.popupBackgroundColor;
}

@end
