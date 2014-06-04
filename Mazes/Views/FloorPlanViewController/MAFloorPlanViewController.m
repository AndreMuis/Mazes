//
//  MAFloorPlanViewController.m
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAFloorPlanViewController.h"

#import "MAFloorPlanView.h"
#import "MAFloorPlanViewDelegate.h"
#import "MAMaze.h"
#import "MAUtilities.h"

@interface MAFloorPlanViewController () <UIScrollViewDelegate>

@property (readonly, strong, nonatomic) id<MAFloorPlanViewDelegate> floorPlanViewDelegate;
@property (readonly, strong, nonatomic) MAMaze *maze;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MAFloorPlanView *floorPlanView;

@end

@implementation MAFloorPlanViewController

+ (MAFloorPlanViewController *)floorPlanViewControllerWithMaze: (MAMaze *)maze
                                         floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
{
    MAFloorPlanViewController *floorPlanViewController = [[MAFloorPlanViewController alloc] initWithNibName: NSStringFromClass([self class])
                                                                                                     bundle: nil
                                                                                                       maze: maze
                                                                                      floorPlanViewDelegate: floorPlanViewDelegate];
    
    return floorPlanViewController;
}

- (instancetype)initWithNibName: (NSString *)nibNameOrNil
                         bundle: (NSBundle *)nibBundleOrNil
                           maze: (MAMaze *)maze
          floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
{
    self = [super init];
    
    if (self)
    {
        _maze = maze;
        _floorPlanViewDelegate = floorPlanViewDelegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = NO;
    
    self.floorPlanView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.floorPlanView setupWithFloorPlanViewDelegate: self.floorPlanViewDelegate
                                                  maze: self.maze];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.floorPlanView updateSizeConstraints];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self updateZoomScale];
}

- (void)updateSize
{
    [self.floorPlanView updateSizeConstraints];
    [self updateZoomScale];
}

- (void)updateZoomScale
{
    CGFloat minimumZoomScale = 0.0;
    
    if (self.floorPlanView.size.width <= self.scrollView.bounds.size.width &&
        self.floorPlanView.size.height <= self.scrollView.bounds.size.height)
    {
        minimumZoomScale = 1.0;
    }
    else if (self.floorPlanView.size.width >= self.floorPlanView.size.height)
    {
        minimumZoomScale = self.scrollView.bounds.size.width / self.floorPlanView.size.width;
    }
    else
    {
        minimumZoomScale = self.scrollView.bounds.size.height / self.floorPlanView.size.height;
    }
    
    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.maximumZoomScale = 1.0;
}

- (void)refreshUI
{
    [self.floorPlanView refreshUI];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.floorPlanView;
}

@end

























