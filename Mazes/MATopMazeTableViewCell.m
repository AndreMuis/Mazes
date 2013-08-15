//
//  MATopMazeTableViewCell.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazeTableViewCell.h"

#import "MACloud.h"
#import "MAConstants.h"
#import "MAMaze.h"
#import "MAMazeRating.h"
#import "MATopMazeItem.h"
#import "MAUser.h"
#import "MAUtilities.h"

#import "MainListViewStyle.h"
#import "RatingView.h"
#import "RatingViewStyle.h"
#import "Styles.h"

@interface MATopMazeTableViewCell ()

@property (strong, nonatomic) MATopMazeItem *topMazeItem1;
@property (strong, nonatomic) MATopMazeItem *topMazeItem2;

@end

@implementation MATopMazeTableViewCell

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
	{
        self.topMazeItem1 = nil;
        self.topMazeItem2 = nil;
        
        _selectedColumn = 0;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer: tapGestureRecognizer];
    }
	
	return self;
}

- (void)setupWithTopMazeItem1: (MATopMazeItem *)topMazeItem1 topMazeItem2: (MATopMazeItem *)topMazeItem2
{
    self.topMazeItem1 = topMazeItem1;
    self.topMazeItem2 = topMazeItem2;
    
    self.name1Label.textColor = [Styles shared].mainListView.textColor;
    self.name1Label.text = self.topMazeItem1.mazeName;
    
    self.date1Label.textColor = [Styles shared].mainListView.textColor;
    self.date1Label.text = self.topMazeItem1.updatedAtFormatted;
    
    self.ratingCount1Label.textColor = [Styles shared].mainListView.textColor;

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
                                         starColor: [Styles shared].ratingView.averageRatingStarColor];
        
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
                                      starColor: [Styles shared].ratingView.userRatingStarColor];
    }
    
    if (self.topMazeItem2 != nil)
    {
        self.name2Label.textColor = [Styles shared].mainListView.textColor;
        self.name2Label.text = self.topMazeItem2.mazeName;
        
        self.date2Label.textColor = [Styles shared].mainListView.textColor;
        self.date2Label.text = self.topMazeItem2.updatedAtFormatted;
        
        self.ratingCount2Label.textColor = [Styles shared].mainListView.textColor;
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
                                             starColor: [Styles shared].ratingView.averageRatingStarColor];
            
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
                                          starColor: [Styles shared].ratingView.userRatingStarColor];
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

- (void)ratingView: (RatingView *)ratingView ratingChanged: (float)newRating
{
    MAMazeRating *rating = [[MAMazeRating alloc] init];
    
    if (ratingView == self.userRating1View)
    {
        rating.maze.objectId = self.topMazeItem1.maze.objectId;
    }
    else if (ratingView == self.userRating2View)
    {
        rating.maze.objectId = self.topMazeItem2.maze.objectId;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Rating view %@ cannot be selectable.", ratingView];
    }
    
    rating.user.objectId = [MACloud shared].currentUserObjectId;
    rating.value = newRating;
    
    // [[ServerQueue shared] addObject: rating];
}

@end


