//
//  MATopWorldsCollectionViewController.m
//  Mazes
//
//  Created by Andre Muis on 6/27/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MATopWorldsCollectionViewController.h"

#import "MACurrentUser.h"
#import "MAGameViewController.h"
#import "MARatingPopoverStyle.h"
#import "MARatingView.h"
#import "MARatingViewController.h"
#import "MARatingViewControllerDelegate.h"
#import "MAStyles.h"
#import "MATopWorldCollectionViewCell.h"
#import "MATopWorldCollectionViewCellDelegate.h"
#import "MAWorldManager.h"
#import "MAWorld.h"

@interface MATopWorldsCollectionViewController () <
    MATopWorldCollectionViewCellDelegate,
    MARatingViewControllerDelegate>

@property (readonly, strong, nonatomic) MAStyles *styles;
@property (readonly, strong, nonatomic) MAWorldManager *worldManager;

@end

@implementation MATopWorldsCollectionViewController


- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _styles = [MAStyles styles];
        _worldManager = [MAWorldManager worldManager];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor colorWithRed: 255.0 / 255.0
                                                          green: 242.0 / 255.0
                                                           blue: 213.0 / 255.0
                                                          alpha: 1.0];
    
    [self.collectionView registerNib: [MATopWorldCollectionViewCell nib]
          forCellWithReuseIdentifier: [MATopWorldCollectionViewCell resuseIdentifier]];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.itemSize = CGSizeMake(250.0, 114.0);

    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    
    layout.sectionInset = UIEdgeInsetsMake(10.0, 6.0, 10.0, 6.0);
    
    [[MACurrentUser shared] fetchUserRecordIDWithCompletionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            [self.worldManager getWorldsWithCompletionHandler: ^(NSError *error)
            {
                if (error == nil)
                {
                    [self.collectionView reloadData];
                }
                else
                {
                    NSLog(@"%@", error);
                }
            }];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section
{
    return self.worldManager.worldsCount;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    MATopWorldCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier: [MATopWorldCollectionViewCell resuseIdentifier]
                                                                                        forIndexPath: indexPath];
    
    MAWorld *world = [self.worldManager worldAtIndex: indexPath.row];
    
    [cell setupWithDelegate: self
                      world: world];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)    collectionView: (UICollectionView *)collectionView
  didSelectItemAtIndexPath: (NSIndexPath *)indexPath
{
    MAWorld *world = [self.worldManager worldAtIndex: indexPath.row];

    MAGameViewController *viewController = [MAGameViewController gameViewController];
    
    [viewController setupWithWorld: world];
    
    [self presentViewController: viewController
                       animated: YES
                     completion: nil];
}

#pragma mark - MATopWorldCollectionViewCellDelegate

- (void)topWorldCollectionViewCell: (MATopWorldCollectionViewCell *)topWorldCollectionViewCell
              didTapUserRatingView: (MARatingView *)ratingView
                          forWorld: (MAWorld *)world
{
    MARatingViewController *viewController = [MARatingViewController ratingViewControllerWithDelegate: self
                                                                                                world: world];
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *controller = [viewController popoverPresentationController];
    
    controller.backgroundColor = self.styles.ratingPopover.backgroundColor;
    
    controller.sourceView = (UIView *)ratingView;
    controller.sourceRect = ratingView.bounds;
    
    [self presentViewController: viewController
                       animated: YES
                     completion: nil];
}

#pragma mark - MARatingViewControllerDelegate

- (void)ratingViewController: (MARatingViewController *)ratingViewController
        didChangeRatingValue: (float)ratingValue
                    forWorld: (MAWorld *)world
{
    [world rateWithUserRecordName: [MACurrentUser shared].recordname
                      ratingValue: ratingValue];
    
    [self.collectionView reloadData];
    
    [self.worldManager saveWithWorld: world
                   completionHandler: ^(MAWorld *world, NSError *error)
    {
        if (error == nil)
        {
            [self.collectionView reloadData];

            NSLog(@"saved rating");
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

#pragma mark -

@end
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
