//
//  MATopWorldCollectionViewCell.h
//  Mazes
//
//  Created by Andre Muis on 6/30/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAWorld;

@protocol MATopWorldCollectionViewCellDelegate;

@interface MATopWorldCollectionViewCell : UICollectionViewCell

+ (UINib *)nib;

+ (NSString *)resuseIdentifier;

- (void)setupWithDelegate: (id<MATopWorldCollectionViewCellDelegate>)delegate
                    world: (MAWorld *)world;

@end
