//
//  MATopMazeTableViewCell.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MARatingView.h"

@class MAStyles;
@class MATopMazeItem;

@interface MATopMazeTableViewCell : UITableViewCell <MARatingViewDelegate>

@property (assign, nonatomic) int selectedColumn;

@property (weak, nonatomic) IBOutlet UILabel *name1Label;

@property (weak, nonatomic) IBOutlet MARatingView *averageRating1View;
@property (weak, nonatomic) IBOutlet UILabel *ratingCount1Label;

@property (weak, nonatomic) IBOutlet MARatingView *userRating1View;

@property (weak, nonatomic) IBOutlet UILabel *date1Label;

@property (weak, nonatomic) IBOutlet UIImageView *background2ImageView;

@property (weak, nonatomic) IBOutlet UILabel *name2Label;

@property (weak, nonatomic) IBOutlet MARatingView *averageRating2View;
@property (weak, nonatomic) IBOutlet UILabel *ratingCount2Label;

@property (weak, nonatomic) IBOutlet MARatingView *userRating2View;

@property (weak, nonatomic) IBOutlet UILabel *date2Label;

- (void)setupWithTopMazeItem1: (MATopMazeItem *)topMazeItem1
                 topMazeItem2: (MATopMazeItem *)topMazeItem2;

@end
