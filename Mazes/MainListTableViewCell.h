//
//  MainListTableViewCell.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RatingView.h"

@class MainListItem;

@interface MainListTableViewCell : UITableViewCell <MARatingViewDelegate>

@property (assign, nonatomic) int selectedColumn;

@property (weak, nonatomic) IBOutlet UILabel *name1Label;

@property (weak, nonatomic) IBOutlet RatingView *averageRating1View;
@property (weak, nonatomic) IBOutlet UILabel *ratingCount1Label;

@property (weak, nonatomic) IBOutlet RatingView *userRating1View;

@property (weak, nonatomic) IBOutlet UILabel *date1Label;

@property (weak, nonatomic) IBOutlet UIImageView *background2ImageView;

@property (weak, nonatomic) IBOutlet UILabel *name2Label;

@property (weak, nonatomic) IBOutlet RatingView *averageRating2View;
@property (weak, nonatomic) IBOutlet UILabel *ratingCount2Label;

@property (weak, nonatomic) IBOutlet RatingView *userRating2View;

@property (weak, nonatomic) IBOutlet UILabel *date2Label;

- (void)setupWithMainListItem1: (MainListItem *)aMainListItem1 mainListItem2: (MainListItem *)aMainListItem2;

@end
