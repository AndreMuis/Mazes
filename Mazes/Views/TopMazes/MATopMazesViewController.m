//
//  MATopMazesViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazesViewController.h"

#import "MADesignViewController.h"
#import "MATopMazesCollectionViewController.h"
#import "MATopMazesSegmentedControl.h"



#import "MARatingView.h"

@interface MATopMazesViewController ()

@property (readwrite, weak, nonatomic) IBOutlet UIView *segmentedControlContainerView;

@property (readwrite, weak, nonatomic) IBOutlet UIButton *createButton;
@property (readwrite, weak, nonatomic) IBOutlet UIButton *leaderboardButton;

@property (readonly, strong, nonatomic) MATopMazesSegmentedControl *segmentedControl;

@property (readonly, strong, nonatomic) MATopMazesCollectionViewController *collectionViewController;



@property (weak, nonatomic) IBOutlet UIView *starView;



@end

@implementation MATopMazesViewController

- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _segmentedControl = [MATopMazesSegmentedControl topMazesSegmentedControl];
        
        _collectionViewController = nil;
    }
    
    return self;
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.destinationViewController isMemberOfClass: [MATopMazesCollectionViewController class]] == YES)
    {
        _collectionViewController = segue.destinationViewController;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.segmentedControl addToParentView: self.segmentedControlContainerView];
    
    [self.segmentedControl addTarget: self
                              action: @selector(segmentedControlDidSelectSegment:)
                    forControlEvents: UIControlEventValueChanged];
    
    UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    
    UIImage *buttonBackgroundImage = [[UIImage imageNamed: @"ButtonBackground"] resizableImageWithCapInsets: buttonEdgeInsets];

    UIImage *buttonHighlightedBackgroundImage = [[UIImage imageNamed: @"ButtonHighlightedBackground"] resizableImageWithCapInsets: buttonEdgeInsets];

    [self.createButton setBackgroundImage: buttonBackgroundImage
                                 forState: UIControlStateNormal];

    [self.createButton setBackgroundImage: buttonHighlightedBackgroundImage
                                 forState: UIControlStateHighlighted];
    
    [self.leaderboardButton setBackgroundImage: buttonBackgroundImage
                                      forState: UIControlStateNormal];
    
    [self.leaderboardButton setBackgroundImage: buttonHighlightedBackgroundImage
                                      forState: UIControlStateHighlighted];
    
    
    
    MARatingView *ratingView = [MARatingView ratingView];
    
    [ratingView setupWithRating: 3.5
                      starColor: [UIColor blueColor]
                   outlineWidth: 1.0];
    
    [self.starView addSubview: ratingView];
    
}

- (void)segmentedControlDidSelectSegment: (id)sender
{
    switch (self.segmentedControl.selectedSegmentType)
    {
        case MASegmentTypeHighestRated:
            break;
            
        case MASegmentTypeNewest:
            break;

        default:
            NSLog(@"Segment type set to an illegal value. segmentType = %d", (int)self.segmentedControl.selectedSegmentType);
            
            break;
    }
}

- (IBAction)createButtonTapped: (id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Design"
                                                         bundle: nil];
    
    MADesignViewController *viewController = [storyboard instantiateInitialViewController];
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController: viewController
                       animated: YES
                     completion: nil];
}

- (IBAction)leaderboardButtonTapped: (id)sender
{
}

- (IBAction)unwindToTopMazesViewController: (UIStoryboardSegue *)unwindSegue
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

@end























