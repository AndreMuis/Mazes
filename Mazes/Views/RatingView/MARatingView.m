//
//  MARatingView.m
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MARatingView.h"

#import "MAStarView.h"
#import "MAStarViewDelegate.h"

@interface MARatingView () <MAStarViewDelegate>

@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView1;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView2;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView3;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView4;
@property (readwrite, weak, nonatomic) IBOutlet MAStarView *starView5;

@property (readonly, strong, nonatomic) NSArray *starViews;

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

- (void)setupWithRating: (float)rating
              starColor: (UIColor *)starColor
           outlineWidth: (float)outlineWidth
{
    _rating = rating;
    _starColor = starColor;
    _outlineWidth = outlineWidth;
    
    for (MAStarView *starView in self.starViews)
    {
        [starView setupWithDelegate: self
                              color: self.starColor
                        fillPercent: 0.6
                       outlineWidth: self.outlineWidth];
    }
}

- (void)starViewDidTap: (MAStarView *)starView
{
    NSLog(@"tap");
}

@end






















