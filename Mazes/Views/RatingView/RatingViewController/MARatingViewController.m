//
//  MARatingViewController.m
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MARatingViewController.h"

#import "MARatingView.h"
#import "MARatingPopoverStyle.h"
#import "MAStyles.h"

@implementation MARatingViewController

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

    self.view.backgroundColor = self.styles.ratingPopover.backgroundColor;
}

@end
