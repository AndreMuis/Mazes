//
//  MainListTableViewCell.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MainListTableViewCell.h"

#import "Constants.h"
#import "CurrentUser.h"
#import "MainListItem.h"
#import "MainListViewStyle.h"
#import "Rating.h"
#import "RatingView.h"
#import "RatingViewStyle.h"
#import "ServerQueue.h"
#import "Styles.h"
#import "Utilities.h"

@implementation MainListTableViewCell

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
	{
        self->mainListItem1 = nil;
        self->mainListItem2 = nil;
        
        _selectedColumn = 0;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer: tapGestureRecognizer];
    }
	
	return self;
}

- (void)setupWithMainListItem1: (MainListItem *)aMainListItem1 mainListItem2: (MainListItem *)aMainListItem2
{
    self->mainListItem1 = aMainListItem1;
    self->mainListItem2 = aMainListItem2;
    
    self.name1Label.textColor = [Styles shared].mainListView.textColor;
    self.name1Label.text = self->mainListItem1.mazeName;
    
    self.date1Label.textColor = [Styles shared].mainListView.textColor;
    self.date1Label.text = self->mainListItem1.lastModifiedFormatted;
    
    self.ratingCount1Label.textColor = [Styles shared].mainListView.textColor;

    if (mainListItem1.averageRating == 0.0)
    {
        self.averageRating1View.hidden = YES;
        
        self.ratingCount1Label.text = @"";
    }
    else
    {
        self.averageRating1View.hidden = NO;
        
        [self.averageRating1View setupWithDelegate: self
                                            rating: self->mainListItem1.averageRating
                                              type: MARatingViewDisplayOnly
                                         starColor: [Styles shared].ratingView.averageRatingStarColor];
        
        self.ratingCount1Label.text = [NSString stringWithFormat: @"%d ratings", self->mainListItem1.ratingsCount];
    }
    
    if (mainListItem1.userStarted == NO)
    {
        self.userRating1View.hidden = YES;
    }
    else
    {
        self.userRating1View.hidden = NO;
        
        [self.userRating1View setupWithDelegate: self
                                         rating: self->mainListItem1.userRating
                                           type: MARatingViewEditable
                                      starColor: [Styles shared].ratingView.userRatingStarColor];
    }
    
    if (mainListItem2 != nil)
    {
        self.name2Label.textColor = [Styles shared].mainListView.textColor;
        self.name2Label.text = self->mainListItem2.mazeName;
        
        self.date2Label.textColor = [Styles shared].mainListView.textColor;
        self.date2Label.text = self->mainListItem2.lastModifiedFormatted;
        
        self.ratingCount2Label.textColor = [Styles shared].mainListView.textColor;
        if (mainListItem2.averageRating == 0.0)
        {
            self.averageRating2View.hidden = YES;
            
            self.ratingCount2Label.text = @"";
        }
        else
        {
            self.averageRating2View.hidden = NO;
            
            [self.averageRating2View setupWithDelegate: self
                                                rating: self->mainListItem2.averageRating
                                                  type: MARatingViewDisplayOnly
                                             starColor: [Styles shared].ratingView.averageRatingStarColor];
            
            self.ratingCount2Label.text = [NSString stringWithFormat: @"%d ratings", self->mainListItem2.ratingsCount];
        }
        
        if (self->mainListItem2.userStarted == NO)
        {
            self.userRating2View.hidden = YES;
        }
        else
        {
            self.userRating2View.hidden = NO;
            
            [self.userRating2View setupWithDelegate: self
                                             rating: self->mainListItem2.userRating
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
    Rating *rating = [[Rating alloc] init];
    
    if (ratingView == self.userRating1View)
    {
        rating.mazeId = self->mainListItem1.mazeId;
    }
    else if (ratingView == self.userRating2View)
    {
        rating.mazeId = self->mainListItem2.mazeId;
    }
    else
    {
        [Utilities logWithClass: [self class] format: @"Rating view %@ cannot be selectable.", ratingView];
    }
        
    rating.userId = [CurrentUser shared].id;
    rating.value = newRating;
    
    [[ServerQueue shared] addObject: rating];
}

@end


