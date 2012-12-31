//
//  MainListTableViewCell.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

@interface MainListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

@property (weak, nonatomic) IBOutlet RatingView *viewRatingAvg1;
@property (weak, nonatomic) IBOutlet UILabel *lblNumRatings1;

@property (weak, nonatomic) IBOutlet RatingView *viewRatingUser1;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@property (weak, nonatomic) IBOutlet RatingView *viewRatingAvg2;
@property (weak, nonatomic) IBOutlet UILabel *lblNumRatings2;

@property (weak, nonatomic) IBOutlet RatingView *viewRatingUser2;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;

@property (assign, nonatomic) int touchColumn;

- (BOOL)touchPoint: (CGPoint)touchPoint inViewRatingUser: (RatingView *)viewRatingUser;

@end
