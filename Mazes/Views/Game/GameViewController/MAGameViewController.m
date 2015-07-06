//
//  MAGameViewController.m
//  Mazes
//
//  Created by Andre Muis on 7/5/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAGameViewController.h"

#import "MAGameView.h"
#import "MAWorld.h"

@interface MAGameViewController ()

@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MAGameViewController

+ (instancetype)gameViewController
{
    MAGameViewController *gameViewController = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Game"
                                                         bundle: nil];
    
    gameViewController = [storyboard instantiateInitialViewController];
    
    return gameViewController;
}

- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _world = nil;
    }
    
    return self;
}

- (void)setupWithWorld: (MAWorld *)world
{
    _world = world;
    
    MAGameView *view = (MAGameView *)self.view;
    [view setupWithWorld: self.world];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    MAGameView *view = (MAGameView *)self.view;
    [view drawWorld];
}

@end


















