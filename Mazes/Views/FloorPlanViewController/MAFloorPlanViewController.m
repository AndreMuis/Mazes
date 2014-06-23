//
//  MAFloorPlanViewController.m
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAFloorPlanViewController.h"

#import "MAFloorPlanStyle.h"
#import "MAFloorPlanView.h"
#import "MAFloorPlanViewDelegate.h"
#import "MALocation.h"
#import "MAMaze.h"
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"

@interface MAFloorPlanViewController () <UIScrollViewDelegate>

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readonly, strong, nonatomic) MAMaze *maze;
@property (readonly, weak, nonatomic) id<MAFloorPlanViewDelegate> floorPlanViewDelegate;

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
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _styles = [MAStyles styles];

        _maze = maze;
        _floorPlanViewDelegate = floorPlanViewDelegate;
    }
    
    return self;
}

- (CGFloat)minimumZoomScale
{
    return self.scrollView.minimumZoomScale;
}

- (MALocation *)previousSelectedLocation
{
    return self.floorPlanView.previousSelectedLocation;
}

- (MALocation *)currentSelectedLocation
{
    return self.floorPlanView.currentSelectedLocation;
}

- (MAWall *)currentSelectedWall
{
    return self.floorPlanView.currentSelectedWall;
}

static void *MAFloorPlanViewControllerKVOContext = &MAFloorPlanViewControllerKVOContext;

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context
{
    if (context == MAFloorPlanViewControllerKVOContext)
    {
        if (object == self.maze && ([keyPath isEqualToString: MAMazeRowsKeyPath] || [keyPath isEqualToString: MAMazeColumnsKeyPath]))
        {
            [self updateZoomScale];
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                              message: @"Change of value for object's keyPath not handled."
                           parameters: @{@"keyPath" : keyPath,
                                         @"object" : object}];
        }
    }
    else
    {
        [super observeValueForKeyPath: keyPath
                             ofObject: object
                               change: change
                              context: context];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = self.styles.floorPlan.backgroundColor;
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = NO;
    
    self.floorPlanView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.floorPlanView setupWithDelegate: self.floorPlanViewDelegate
                                     maze: self.maze];

    [self.maze addObserver: self
                forKeyPath: MAMazeRowsKeyPath
                   options: NSKeyValueObservingOptionNew
                   context: MAFloorPlanViewControllerKVOContext];
    
    [self.maze addObserver: self
                forKeyPath: MAMazeColumnsKeyPath
                   options: NSKeyValueObservingOptionNew
                   context: MAFloorPlanViewControllerKVOContext];
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
    
    if (self.scrollView.zoomScale < minimumZoomScale)
    {
        self.scrollView.zoomScale = minimumZoomScale;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.floorPlanView;
}

@end

























