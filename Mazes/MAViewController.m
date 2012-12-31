//
//  MAViewController.m
//  Mazes
//
//  Created by Andre Muis on 12/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAViewController.h"

@implementation MAViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        self->movingToParentViewController = NO;
        self->didLayoutSubviews = NO;
    }
    
    return self;
}

- (void)willMoveToParentViewController: (UIViewController *)parent
{
    [super willMoveToParentViewController: parent];
    
    if (parent != nil)
    {
        self->movingToParentViewController = YES;
        self->didLayoutSubviews = NO;
    }
}

- (void)didMoveToParentViewController: (UIViewController *)parent
{
    self->movingToParentViewController = NO;

    [super didMoveToParentViewController: parent];
}

- (void)viewDidLayoutSubviews
{
    if (self->movingToParentViewController == YES && self->didLayoutSubviews == NO)
    {
        self->didLayoutSubviews = YES;
    }
    
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
