//
//  TopListsTableViewCell.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

@interface TopListsTableViewCell : UITableViewCell
{
	UILabel *nameLabel1;
	
	RatingView *viewRatingAvg1;
	UILabel *lblNumRatings1;
	
	RatingView *viewRatingUser1;
	
	UILabel *dateLabel1;

	UIImageView *imageViewBackground2;
	
	UILabel *nameLabel2;

	RatingView *viewRatingAvg2;
	UILabel *lblNumRatings2;
	
	RatingView *viewRatingUser2;
		
	UILabel *dateLabel2;
	
	int touchColumn;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel1;

@property (nonatomic, retain) IBOutlet RatingView *viewRatingAvg1;
@property (nonatomic, retain) IBOutlet UILabel *lblNumRatings1;

@property (nonatomic, retain) IBOutlet RatingView *viewRatingUser1;

@property (nonatomic, retain) IBOutlet UILabel *dateLabel1;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewBackground2;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel2;

@property (nonatomic, retain) IBOutlet RatingView *viewRatingAvg2;
@property (nonatomic, retain) IBOutlet UILabel *lblNumRatings2;

@property (nonatomic, retain) IBOutlet RatingView *viewRatingUser2;

@property (nonatomic, retain) IBOutlet UILabel *dateLabel2;

@property (nonatomic) int touchColumn;

- (BOOL)TouchPoint: (CGPoint)touchPoint InViewRatingUser: (RatingView *)viewRatingUser;

@end
