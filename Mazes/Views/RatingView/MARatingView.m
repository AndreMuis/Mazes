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
@property (readonly, assign, nonatomic) float rating;
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
        _rating = 0.0;
        _starColor = nil;
        _outlineWidth = 0.0;
    }
    
    return self;
}

- (void)awakeFromNib
{
    _starViews = @[self.starView1, self.starView2, self.starView3, self.starView4, self.starView5];
}

- (void)setupWithDelegate: (id<MARatingViewDelegate>)delegate
                   rating: (float)rating
                starColor: (UIColor *)starColor
             outlineWidth: (float)outlineWidth
{
    _delegate = delegate;
    _rating = rating;
    _starColor = starColor;
    _outlineWidth = outlineWidth;
    
    for (NSUInteger star = 1; star <= 5; star = star + 1)
    {
        MAStarView *starView = [self.starViews objectAtIndex: star - 1];
        
        if (rating <= star - 1)
        {
            [starView setupWithDelegate: self
                                  color: self.starColor
                            fillPercent: 0.0
                           outlineWidth: self.outlineWidth];
        }
        else if (rating > star - 1 && rating <= star)
        {
            [starView setupWithDelegate: self
                                  color: self.starColor
                            fillPercent: rating - (star - 1)
                           outlineWidth: self.outlineWidth];
        }
        else
        {
            [starView setupWithDelegate: self
                                  color: self.starColor
                            fillPercent: 1.0
                           outlineWidth: self.outlineWidth];
        }
    }
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
    float rating = (float)([self.starViews indexOfObject: starView] + 1);
    
    [self.delegate ratingView: self
             didTapWithRating: rating];
}

@end






















