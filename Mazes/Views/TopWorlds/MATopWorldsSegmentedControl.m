//
//  MATopWorldsSegmentedControl.m
//  Mazes
//
//  Created by Andre Muis on 6/27/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MATopWorldsSegmentedControl.h"

@interface MATopWorldsSegmentedControl ()

@property (readwrite, weak, nonatomic) IBOutlet UIButton *firstSegmentButton;
@property (readwrite, weak, nonatomic) IBOutlet UIButton *secondSegmentButton;

@end

@implementation MATopWorldsSegmentedControl

+ (instancetype)topWorldsSegmentedControl
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class])
                                                             owner: nil
                                                           options: nil];
    
    MATopWorldsSegmentedControl *segmentedControl = topLevelObjects[0];
    
    return segmentedControl;
}

- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _selectedSegmentType = MASegmentTypeUnknown;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    
    
    self.firstSegmentButton.adjustsImageWhenHighlighted = NO;
    
    UIImage *firstSegmentBackgroundImage = [[UIImage imageNamed: @"SegmentLeft"] resizableImageWithCapInsets: buttonEdgeInsets];
    
    UIImage *firstSegmentSelectedBackgroundImage = [[UIImage imageNamed: @"SegmentLeftSelected"] resizableImageWithCapInsets: buttonEdgeInsets];
    
    [self.firstSegmentButton setBackgroundImage: firstSegmentBackgroundImage
                                       forState: UIControlStateNormal];
    
    [self.firstSegmentButton setBackgroundImage: firstSegmentSelectedBackgroundImage
                                       forState: UIControlStateSelected];
    
    [self.firstSegmentButton setTitle: @"TOP RATED"
                             forState: UIControlStateNormal];

    [self.firstSegmentButton setTitleColor: [UIColor whiteColor]
                                  forState: UIControlStateNormal];

    
    self.secondSegmentButton.adjustsImageWhenHighlighted = NO;

    UIImage *secondSegmentBackgroundImage = [[UIImage imageNamed: @"SegmentRight"] resizableImageWithCapInsets: buttonEdgeInsets];
    
    UIImage *secondSegmentSelectedBackgroundImage = [[UIImage imageNamed: @"SegmentRightSelected"] resizableImageWithCapInsets: buttonEdgeInsets];

    [self.secondSegmentButton setBackgroundImage: secondSegmentBackgroundImage
                                        forState: UIControlStateNormal];

    [self.secondSegmentButton setBackgroundImage: secondSegmentSelectedBackgroundImage
                                        forState: UIControlStateSelected];

    [self.secondSegmentButton setTitle: @"NEWEST"
                              forState: UIControlStateNormal];

    [self.secondSegmentButton setTitleColor: [UIColor whiteColor]
                                   forState: UIControlStateNormal];
}

- (void)addToParentView: (UIView *)parentView
{
    [parentView addSubview: self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;

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

- (IBAction)firstSegmentButtonTapped: (id)sender
{
    if (self.selectedSegmentType != MASegmentTypeHighestRated)
    {
        _selectedSegmentType = MASegmentTypeHighestRated;
        
        self.firstSegmentButton.selected = YES;
        self.secondSegmentButton.selected = NO;
    }
    
    [self sendActionsForControlEvents: UIControlEventValueChanged];
}

- (IBAction)secondSegmentButtonTapped: (id)sender
{
    if (self.selectedSegmentType != MASegmentTypeNewest)
    {
        _selectedSegmentType = MASegmentTypeNewest;

        self.firstSegmentButton.selected = NO;
        self.secondSegmentButton.selected = YES;
    }
    
    [self sendActionsForControlEvents: UIControlEventValueChanged];
}

@end



















