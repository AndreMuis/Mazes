//
//  MATopMazesCollectionViewController.m
//  Mazes
//
//  Created by Andre Muis on 6/27/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MATopMazesCollectionViewController.h"

#import "MATopMazesCollectionViewCell.h"

@interface MATopMazesCollectionViewController ()

@end

@implementation MATopMazesCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed: 255.0 / 255.0
                                                          green: 242.0 / 255.0
                                                           blue: 213.0 / 255.0
                                                          alpha: 1.0];
    
    [self.collectionView registerNib: [MATopMazesCollectionViewCell nib]
          forCellWithReuseIdentifier: [MATopMazesCollectionViewCell resuseIdentifier]];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.itemSize = CGSizeMake(250.0, 114.0);

    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    
    layout.sectionInset = UIEdgeInsetsMake(10.0, 6.0, 10.0, 6.0);
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section
{
    return 100.0;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    MATopMazesCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier: [MATopMazesCollectionViewCell resuseIdentifier]
                                                                                        forIndexPath: indexPath];
    
    return cell;
}

@end
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
