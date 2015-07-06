//
//  MATopWorldCollectionViewCellDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MARatingView;
@class MATopWorldCollectionViewCell;
@class MAWorld;

@protocol MATopWorldCollectionViewCellDelegate <NSObject>

@required
- (void)topWorldCollectionViewCell: (MATopWorldCollectionViewCell *)topWorldCollectionViewCell
              didTapUserRatingView: (MARatingView *)ratingView
                          forWorld: (MAWorld *)world;

@end

