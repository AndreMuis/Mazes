//
//  MARatingView.m
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MARatingView.h"

#import "MARatingViewDelegate.h"
#import "MAStarView.h"
#import "MAStarViewDelegate.h"

@interface MARatingView () <MAStarViewDelegate>

@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView1;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView2;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView3;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView4;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView5;

@property (readonly, strong, nonatomic) NSArray *starViews;

@property (readonly, weak, nonatomic) id<MARatingViewDelegate> delegate;
@property (readonly, assign, nonatomic) float ratingValue;
@property (readonly, strong, nonatomic) UIColor *starColor;
@property (readonly, assign, nonatomic) float outlineWidth;

@end

@implementation MARatingView

+ (instancetype)ratingView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class])
                                                             owner: nil
                                                           options: nil];
    
    MARatingView *ratingView = topLevelObjects[0];
    
    return ratingView;
}

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _starViews = nil;
        
        _delegate = nil;
        _ratingValue = 0.0;
        _starColor = nil;
        _outlineWidth = 0.0;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    _starViews = @[self.starView1, self.starView2, self.starView3, self.starView4, self.starView5];
}

- (void)setupWithStarColor: (UIColor *)starColor
              outlineWidth: (float)outlineWidth
{
    [self setupWithDelegate: nil
                ratingValue: 0.0
                  starColor: starColor
               outlineWidth: outlineWidth];
}

- (void)setupWithDelegate: (id<MARatingViewDelegate>)delegate
              ratingValue: (float)ratingValue
                starColor: (UIColor *)starColor
             outlineWidth: (float)outlineWidth
{
    _delegate = delegate;
    _ratingValue = ratingValue;
    _starColor = starColor;
    _outlineWidth = outlineWidth;
    
    for (NSUInteger starCount = 1; starCount <= 5; starCount = starCount + 1)
    {
        MAStarView *starView = [self.starViews objectAtIndex: starCount - 1];
        
        float fillPercent = [self starFillPercentWithStarCount: starCount
                                                   ratingValue: ratingValue];
        
        if (self.delegate == nil)
        {
            [starView setupWithColor: self.starColor
                         fillPercent: fillPercent
                        outlineWidth: self.outlineWidth];
        }
        else
        {
            [starView setupWithDelegate: self
                                  color: self.starColor
                            fillPercent: fillPercent
                           outlineWidth: self.outlineWidth];
        }
    }
}

- (void)refreshWithRatingValue: (float)ratingValue
{
    _ratingValue = ratingValue;
    
    for (NSUInteger starCount = 1; starCount <= 5; starCount = starCount + 1)
    {
        MAStarView *starView = [self.starViews objectAtIndex: starCount - 1];
        
        float fillPercent = [self starFillPercentWithStarCount: starCount
                                                   ratingValue: ratingValue];
        
        [starView refreshUIWithFillPercent: fillPercent];
    }
}

- (float)starFillPercentWithStarCount: (float)starCount
                          ratingValue: (float)ratingValue
{
    float fillPercent = 0.0;

    if (ratingValue <= starCount - 1)
    {
        fillPercent = 0.0;
    }
    else if (ratingValue > starCount - 1 && ratingValue < starCount)
    {
        fillPercent = ratingValue - (starCount - 1);
    }
    else
    {
        fillPercent = 1.0;
    }

    return fillPercent;
}

- (void)addToParentView: (UIView *)parentView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [parentView addSubview: self];
    
    NSDictionary *views = @{@"self" : self};
    
    [parentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[self]-0-|"
                                                                        options: 0
                                                                        metrics: nil
                                                                          views: views]];
    
    [parentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[self]-0-|"
                                                                        options: 0
                                                                        metrics: nil
                                                                          views: views]];
}

- (void)starViewDidTap: (MAStarView *)starView
{
    float ratingValue = (float)([self.starViews indexOfObject: starView] + 1);
    
    [self.delegate ratingView: self
        didTapWithRatingValue: ratingValue];
}

@end






















