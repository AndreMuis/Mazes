//
//  MAFoundExitPopupView.m
//  Mazes
//
//  Created by Andre Muis on 10/11/12.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAFoundExitPopupView.h"

#import "MAFoundExitPopupStyle.h"
#import "MAStyles.h"

@interface MAFoundExitPopupView ()

@property (readonly, strong, nonatomic) id<MARatingViewDelegate> ratingViewDelegate;

@property (weak, nonatomic) IBOutlet MARatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MAFoundExitPopupView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
    }
    
    return self;
}

+ (MAFoundExitPopupView *)foundExitPopupView
{
    return [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner: nil options: nil] objectAtIndex: 0];
}

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
    ratingViewDelegate: (id<MARatingViewDelegate>)ratingViewDelegate
                rating: (float)rating
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler
{
    [super showWithParentView: parentView
             dismissedHandler: dismissedHandler];
    
    _ratingViewDelegate = ratingViewDelegate;
    
    self.ratingView.backgroundColor = [UIColor clearColor];
    
    [self.ratingView setupWithDelegate: self
                                rating: rating
                                  type: MARatingViewSelectable
                             starColor: self.styles.foundExitPopup.ratingStarColor];
    
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.messageLabel.textColor = self.styles.foundExitPopup.textColor;
    self.messageLabel.font = self.styles.foundExitPopup.font;

    self.messageLabel.text = @"Click a star above to rate.";

    [parentView addSubview: self];
    
    [self animateUp];
}

- (void)ratingView: (MARatingView *)ratingView ratingChanged: (float)newRating
{
    [self animateDown];
    
    [self.ratingViewDelegate ratingView: self.ratingView ratingChanged: newRating];
}

- (IBAction)cancelButtonTouchDown: (id)sender
{
    [self animateDown];
}

@end





















