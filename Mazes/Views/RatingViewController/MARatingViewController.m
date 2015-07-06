//
//  MARatingViewController.m
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MARatingViewController.h"

#import "MACurrentUser.h"
#import "MARatingView.h"
#import "MARatingViewControllerDelegate.h"
#import "MARatingViewDelegate.h"
#import "MAWorld.h"
#import "MAWorldRating.h"

@interface MARatingViewController () <MARatingViewDelegate>

@property (readwrite, weak, nonatomic) IBOutlet MARatingView *ratingContainerView;

@property (readonly, strong, nonatomic) MARatingView *ratingView;

@property (readonly, weak, nonatomic) id<MARatingViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MARatingViewController

+ (instancetype)ratingViewControllerWithDelegate: (id<MARatingViewControllerDelegate>)delegate
                                           world: (MAWorld *)world
{
    MARatingViewController *viewController = [[self alloc] initWithDelegate: delegate
                                                                      world: world];
    
    return viewController;
}

- (instancetype)initWithDelegate: (id<MARatingViewControllerDelegate>)delegate
                           world: (MAWorld *)world
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _ratingView = [MARatingView ratingView];
        
        _delegate = delegate;
        _world = world;
    }
    
    return self;
}

- (CGSize)preferredContentSize
{
    return self.view.bounds.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    float userRatingValue = 0.0;
    
    if ([self.world hasRatingWithUserRecordName: [MACurrentUser shared].recordname] == YES)
    {
        userRatingValue = [self.world ratingValueWithUserRecordName: [MACurrentUser shared].recordname];
    }
    
    [self.ratingView setupWithDelegate: self
                           ratingValue: userRatingValue
                             starColor: [UIColor blueColor]
                          outlineWidth: 1.0];
    
    [self.ratingView addToParentView: self.ratingContainerView];
}

- (void)     ratingView: (MARatingView *)ratingView
  didTapWithRatingValue: (float)ratingValue
{
    [self.ratingView refreshWithRatingValue: ratingValue];
    
    [self.delegate ratingViewController: self
                   didChangeRatingValue: ratingValue
                               forWorld: self.world];
}

@end






















