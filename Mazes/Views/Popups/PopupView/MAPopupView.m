//
//  MAPopupView.m
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAPopupView.h"

#import "MAButton.h"
#import "MAPopupStyle.h"
#import "MAStyles.h"

@interface MAPopupView ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readonly, strong, nonatomic) UIView *parentView;
@property (readonly, copy, nonatomic) PopupViewDismissedHandler dismissedHandler;

@property (readonly, strong, nonatomic) UIView *translucentBackgroundView;

@end

@implementation MAPopupView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        _styles = [MAStyles styles];
    }
    
    return self;
}

- (void)setupWithParentView: (UIView *)parentView
{
    _parentView = parentView;
}

- (void)showWithDismissedHandler: (PopupViewDismissedHandler)dismissedHandler
{
    _dismissedHandler = dismissedHandler;
    
    _translucentBackgroundView = [[UIView alloc] initWithFrame: self.parentView.frame];
    [self.parentView addSubview: self.translucentBackgroundView];
    
    [self.parentView addSubview: self];
    
    self.backgroundColor = self.styles.popup.backgroundColor;
    self.layer.cornerRadius = self.styles.popup.cornerRadius;
    self.layer.borderWidth = self.styles.popup.borderWidth;
    self.layer.borderColor = self.styles.popup.borderColor.CGColor;
}

- (void)centerInParentView
{
    self.frame = CGRectMake((self.parentView.frame.size.width - self.frame.size.width) / 2.0,
                            (self.parentView.frame.size.height - self.frame.size.height) / 2.0,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)cancelButtonWidth: (MAButton *)cancelButton
{
    NSDictionary *attributes = @{NSFontAttributeName : cancelButton.titleLabel.font};
    
    CGSize cancelButtonTitleSize = [cancelButton.currentTitle sizeWithAttributes: attributes];
    
    CGFloat cancelButtonWidth = cancelButton.titleEdgeInsets.left + cancelButtonTitleSize.width + cancelButton.titleEdgeInsets.right;
    
    return cancelButtonWidth;
}

- (void)animateUp
{
    self.translucentBackgroundView.backgroundColor = [UIColor clearColor];
    
    CGFloat initialScale = self.styles.popup.initialScale;
    CGFloat bounceScalePercent = self.styles.popup.bounceScalePercent;
    
    self.transform = CGAffineTransformScale(self.transform,
                                            initialScale,
                                            initialScale);
    
    [UIView animateWithDuration: self.styles.popup.initialAnimationDuration
                     animations: ^(void)
     {
         self.translucentBackgroundView.backgroundColor = self.styles.popup.translucentBackgroundColor;
         
         self.transform = CGAffineTransformScale(self.transform,
                                                 (1.0 / initialScale) * (1.0 + bounceScalePercent),
                                                 (1.0 / initialScale) * (1.0 + bounceScalePercent));
     }
                     completion: ^(BOOL finished)
     {
         [UIView animateWithDuration: self.styles.popup.otherAnimationDuration
                          animations: ^(void)
          {
              self.transform = CGAffineTransformScale(self.transform,
                                                      (1.0 / (1.0 + bounceScalePercent)) * (1.0 - bounceScalePercent),
                                                      (1.0 / (1.0 + bounceScalePercent)) * (1.0 - bounceScalePercent));
          }
                          completion: ^(BOOL finished)
          {
              [UIView animateWithDuration: self.styles.popup.otherAnimationDuration
                               animations: ^(void)
               {
                   self.transform = CGAffineTransformIdentity;
               }
                               completion: ^(BOOL finished)
               {
               }];
          }];
     }];
}

- (void)animateDown
{
    CGFloat initialScale = self.styles.popup.initialScale;
    
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration: self.styles.popup.otherAnimationDuration
                     animations: ^(void)
     {
         self.translucentBackgroundView.backgroundColor = [UIColor clearColor];
         
         self.transform = CGAffineTransformScale(self.transform,
                                                 initialScale,
                                                 initialScale);
     }
                     completion: ^(BOOL finished)
     {
         self.transform = CGAffineTransformIdentity;
         
         [self.translucentBackgroundView removeFromSuperview];
         [self removeFromSuperview];
         
         self.dismissedHandler();
     }];
}

@end








