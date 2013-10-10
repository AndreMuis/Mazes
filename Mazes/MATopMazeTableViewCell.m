//
//  MATopMazeTableViewCell.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazeTableViewCell.h"

#import "AppDelegate.h"
#import "MACloud.h"
#import "MAConstants.h"
#import "MAMainListViewStyle.h"
#import "MAMaze.h"
#import "MAMazeRating.h"
#import "MARatingView.h"
#import "MARatingViewStyle.h"
#import "MAStyles.h"
#import "MATopMazeItem.h"
#import "MAUtilities.h"

@interface MATopMazeTableViewCell ()

@property (strong, nonatomic) MATopMazeItem *topMazeItem1;
@property (strong, nonatomic) MATopMazeItem *topMazeItem2;

@property (readonly, strong, nonatomic) MAStyles *styles;

@end

@implementation MATopMazeTableViewCell

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
	{
        _topMazeItem1 = nil;
        _topMazeItem2 = nil;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _styles = appDelegate.styles;
        
        _selectedColumn = 0;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer: tapGestureRecognizer];
    }
	
	return self;
}

- (void)setupWithTopMazeItem1: (MATopMazeItem *)topMazeItem1
                 topMazeItem2: (MATopMazeItem *)topMazeItem2
{
    self.topMazeItem1 = topMazeItem1;
    self.topMazeItem2 = topMazeItem2;
 
    self.name1Label.textColor = self.styles.mainListView.textColor;
    self.name1Label.text = self.topMazeItem1.mazeName;
    
    self.date1Label.textColor = self.styles.mainListView.textColor;
    self.date1Label.text = self.topMazeItem1.modifiedAtFormatted;
    
    self.ratingCount1Label.textColor = self.styles.mainListView.textColor;

    if (self.topMazeItem1.averageRating == 0.0)
    {
        self.averageRating1View.hidden = YES;
        
        self.ratingCount1Label.text = @"";
    }
    else
    {
        self.averageRating1View.hidden = NO;
        
        [self.averageRating1View setupWithDelegate: self
                                            rating: self.topMazeItem1.averageRating
                                              type: MARatingViewDisplayOnly
                                         starColor: self.styles.ratingView.averageRatingStarColor];
        
        self.ratingCount1Label.text = [NSString stringWithFormat: @"%d ratings", self.topMazeItem1.ratingCount];
    }
    
    if (self.topMazeItem1.userStarted == NO)
    {
        self.userRating1View.hidden = YES;
    }
    else
    {
        self.userRating1View.hidden = NO;
        
        [self.userRating1View setupWithDelegate: self
                                         rating: self.topMazeItem1.userRating
                                           type: MARatingViewEditable
                                      starColor: self.styles.ratingView.userRatingStarColor];
    }
    
    if (self.topMazeItem2 != nil)
    {
        self.name2Label.textColor = self.styles.mainListView.textColor;
        self.name2Label.text = self.topMazeItem2.mazeName;
        
        self.date2Label.textColor = self.styles.mainListView.textColor;
        self.date2Label.text = self.topMazeItem2.modifiedAtFormatted;
        
        self.ratingCount2Label.textColor = self.styles.mainListView.textColor;
        if (self.topMazeItem2.averageRating == 0.0)
        {
            self.averageRating2View.hidden = YES;
            
            self.ratingCount2Label.text = @"";
        }
        else
        {
            self.averageRating2View.hidden = NO;
            
            [self.averageRating2View setupWithDelegate: self
                                                rating: self.topMazeItem2.averageRating
                                                  type: MARatingViewDisplayOnly
                                             starColor: self.styles.ratingView.averageRatingStarColor];
            
            self.ratingCount2Label.text = [NSString stringWithFormat: @"%d ratings", self.topMazeItem2.ratingCount];
        }
        
        if (self.topMazeItem2.userStarted == NO)
        {
            self.userRating2View.hidden = YES;
        }
        else
        {
            self.userRating2View.hidden = NO;
            
            [self.userRating2View setupWithDelegate: self
                                             rating: self.topMazeItem2.userRating
                                               type: MARatingViewEditable
                                          starColor: self.styles.ratingView.userRatingStarColor];
        }
    }
    else
    {
        self.background2ImageView.hidden = YES;
        
        self.name2Label.text = @"";
        self.date2Label.text = @"";
        
        self.averageRating2View.hidden = YES;        
        self.ratingCount2Label.text = @"";
        
        self.userRating2View.hidden = YES;
    }
}

- (void)handleTapFrom: (UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint tapPoint = [tapGestureRecognizer locationInView: self];
    
    if (tapPoint.x < self.frame.size.width / 2.0)
    {
		self.selectedColumn = 1;
    }
	else
    {
		self.selectedColumn = 2;
    }
}

- (void)ratingView: (MARatingView *)ratingView ratingChanged: (float)newRating
{
    MAMazeRating *rating = [[MAMazeRating alloc] init];
    
    if (ratingView == self.userRating1View)
    {
        rating.maze = self.topMazeItem1.maze;
    }
    else if (ratingView == self.userRating2View)
    {
        rating.maze = self.topMazeItem2.maze;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Rating view %@ cannot be selectable.", ratingView];
    }
    
    // rating.user = [MAUserManager shared].currentUser;
    rating.userRating = newRating;
    
    // [[ServerQueue shared] addObject: rating];
}

@end






















