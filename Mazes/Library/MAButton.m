//
//  MAButton.m
//  Mazes
//
//  Created by Andre Muis on 4/17/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAButton.h"

#import "MAButtonStyle.h"
#import "MAStyles.h"

@interface MAButton ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readonly, strong, nonatomic) UIView *translucentOverlayView;
@property (readonly, strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MAButton

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];

    if (self)
    {
        _styles = [MAStyles styles];
        
        _translucentOverlayView = [[UIView alloc] init];
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: self.styles.button.activityIndicatorStyle];
    }

    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = self.styles.button.backgroundColor;
    
    self.layer.borderWidth = self.styles.button.borderWidth;
    self.layer.borderColor = self.styles.button.borderColor.CGColor;

    self.layer.cornerRadius = self.styles.button.cornerRadius;
    self.layer.masksToBounds = YES;
    
    [self setTitleColor: self.styles.button.titleColor forState: UIControlStateNormal];
    self.titleLabel.font = self.styles.button.titleFont;
    
    self.translucentOverlayView.backgroundColor = self.styles.button.translucentOverlayViewBackgroundColor;
    self.translucentOverlayView.frame = self.bounds;
    
    self.activityIndicatorView.frame = CGRectMake((self.bounds.size.width - self.activityIndicatorView.bounds.size.width) / 2.0,
                                                  (self.bounds.size.height - self.activityIndicatorView.bounds.size.height) / 2.0,
                                                  self.activityIndicatorView.bounds.size.width,
                                                  self.activityIndicatorView.bounds.size.height);
}

- (void)setIsBusy: (BOOL)isBusy
{
    _isBusy = isBusy;
    
    if (_isBusy == YES)
    {
        [self addSubview: self.translucentOverlayView];
        
        [self.activityIndicatorView startAnimating];
        [self addSubview: self.activityIndicatorView];
    }
    else
    {
        [self.translucentOverlayView removeFromSuperview];
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
}

@end

















