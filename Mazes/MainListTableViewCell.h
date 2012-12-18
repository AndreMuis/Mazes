//
//  MainListTableViewCell.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

@interface MainListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel1;

@property (strong, nonatomic) IBOutlet RatingView *viewRatingAvg1;
@property (strong, nonatomic) IBOutlet UILabel *lblNumRatings1;

@property (strong, nonatomic) IBOutlet RatingView *viewRatingUser1;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel1;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground2;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel2;

@property (strong, nonatomic) IBOutlet RatingView *viewRatingAvg2;
@property (strong, nonatomic) IBOutlet UILabel *lblNumRatings2;

@property (strong, nonatomic) IBOutlet RatingView *viewRatingUser2;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel2;

@property (nonatomic, assign) int touchColumn;

- (BOOL)TouchPoint: (CGPoint)touchPoint InViewRatingUser: (RatingView *)viewRatingUser;

@end
