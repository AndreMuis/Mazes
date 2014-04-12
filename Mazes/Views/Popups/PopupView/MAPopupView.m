//
//  MAPopupView.m
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAPopupView.h"

#import "MAPopupStyle.h"
#import "MAStyles.h"

@interface MAPopupView ()

@property (readonly, copy, nonatomic) PopupViewDismissedHandler dismissedHandler;
@property (readonly, strong, nonatomic) UIView *translucentBackground;

@end

@implementation MAPopupView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
    }
    
    return self;
}

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler
{
    _styles = styles;
    
    _dismissedHandler = dismissedHandler;
    
    _translucentBackground = [[UIView alloc] initWithFrame: parentView.frame];
    [parentView addSubview: self.translucentBackground];
    
    self.frame = CGRectMake((parentView.frame.size.width - self.frame.size.width) / 2.0,
                            (parentView.frame.size.height - self.frame.size.height) / 2.0,
                            self.frame.size.width,
                            self.frame.size.height);
    
    self.backgroundColor = self.styles.popup.backgroundColor;
    self.layer.cornerRadius = self.styles.popup.cornerRadius;
    self.layer.borderWidth = self.styles.popup.borderWidth;
    self.layer.borderColor = self.styles.popup.borderColor.CGColor;
}

- (void)animateUp
{
    self.translucentBackground.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.0];
    
    CGFloat initialScale = self.styles.popup.initialScale;
    CGFloat bounceScalePercent = self.styles.popup.bounceScalePercent;
    
    self.transform = CGAffineTransformScale(self.transform,
                                            initialScale,
                                            initialScale);
    
    [UIView animateWithDuration: self.styles.popup.initialAnimationDuration
                     animations: ^(void)
     {
         self.translucentBackground.backgroundColor = self.styles.popup.translucentBackgroundColor;
         
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
         self.translucentBackground.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.0];
         
         self.transform = CGAffineTransformScale(self.transform,
                                                 initialScale,
                                                 initialScale);
     }
                     completion: ^(BOOL finished)
     {
         self.transform = CGAffineTransformIdentity;
         
         [self.translucentBackground removeFromSuperview];
         [self removeFromSuperview];
         
         self.dismissedHandler();
     }];
}

@end








