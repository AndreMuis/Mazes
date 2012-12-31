//
//  MainListTableViewCell.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MainListTableViewCell.h"

#import "Constants.h"
#import "RatingView.h"

@implementation MainListTableViewCell

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event 
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView: self];
	
	// if touch is in Expanded User Rating View cancel touches and call rating popup
	if ([self touchPoint: touchPoint inViewRatingUser: self.viewRatingUser1] == YES)
	{
		if (self.viewRatingUser1.mode == MARatingModeDisplayUser)
        {
			[self.viewRatingUser1 showRatingPopover];
        }
		else
        {
			[super touchesBegan: touches withEvent: event];
        }
	}
	else if ([self touchPoint: touchPoint inViewRatingUser: self.viewRatingUser2] == YES)
	{
		if (self.viewRatingUser2.mode == MARatingModeDisplayUser)
        {
			[self.viewRatingUser2 showRatingPopover];
        }
		else
        {
			[super touchesBegan: touches withEvent: event];		
        }
	}
	else 
	{
		[super touchesBegan: touches withEvent: event];					
	}
	
	if (touchPoint.x < self.frame.size.width / 2.0)
    {
		self.touchColumn = 1;
    }
	else
    {
		self.touchColumn = 2;
    }
}

- (BOOL)touchPoint: (CGPoint)touchPoint inViewRatingUser: (RatingView *)viewRatingUser
{
	float x = viewRatingUser.frame.origin.x - viewRatingUser.starWidth / 2.0;
	float y = viewRatingUser.frame.origin.y - viewRatingUser.starHeight / 2.0;
	float width = viewRatingUser.frame.size.width + viewRatingUser.starWidth;
	float height = self.frame.size.height - y;
	
	CGRect expandedRect = CGRectMake(x, y, width, height);

	BOOL touchedInView = (CGRectContainsPoint(expandedRect, touchPoint));
	
	return touchedInView;
}

@end


