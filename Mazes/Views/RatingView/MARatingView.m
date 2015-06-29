//
//  MARatingView.m
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MARatingView.h"

#import "MAGameViewController.h"
#import "MARatingViewController.h"
#import "MAStyles.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

@interface MARatingView ()

@property (weak, nonatomic) id<MARatingViewDelegate> delegate;

@property (assign, nonatomic) float rating;
@property (strong, nonatomic) UIColor *starColor;
@property (assign, nonatomic) MARatingViewType type;

@property (assign, nonatomic) CGFloat starWidth;
@property (assign, nonatomic) CGFloat starHeight;
    
@property (strong, nonatomic) UIPopoverController* popoverController;

@end

@implementation MARatingView

- (id)initWithCoder: (NSCoder*)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _delegate = nil;
        
        _rating = 0.0;
        _starColor = nil;
        _type = MARatingViewUnknown;
        
        _starWidth = 0.0;
        _starHeight = 0.0;
        
        _popoverController = nil;
    }
    
    return self;
}

- (void)setupWithDelegate: (id<MARatingViewDelegate>)delegate
                   rating: (float)rating
                     type: (MARatingViewType)type
                starColor: (UIColor *)starColor
{
    self.delegate = delegate;
    self.rating = rating;
    self.starColor = starColor;
    self.type = type;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.starWidth = self.frame.size.width / 5.0;
    self.starHeight = self.frame.size.height;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
    [self addGestureRecognizer: tapGestureRecognizer];
}

- (void)drawRect: (CGRect)rect
{
    if (self.hidden == NO)
    {
        for (float i = 1.0; i <= 5.0; i = i + 1.0)
        {
            float starX = self.starWidth * (i - 1);
            float starY = rect.origin.y;
            
            if (i <= self.rating)
            {
                [MAUtilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                                   clipRect: CGRectZero
                                      color: self.starColor
                                    outline: NO];
            }
            else if (i > ceilf(self.rating))
            {
                [MAUtilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                                   clipRect: CGRectZero
                                      color: self.starColor
                                    outline: YES];
            }
            else
            {
                float fract = self.rating - floorf(self.rating);
                
                [MAUtilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                                   clipRect: CGRectMake(starX, starY, fract * self.starWidth, self.starHeight)
                                      color: self.starColor
                                    outline: NO];
                
                [MAUtilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                                   clipRect: CGRectMake(starX + fract * self.starWidth, starY, self.starWidth - fract * self.starWidth, self.starHeight)
                                      color: self.starColor
                                    outline: YES];
            }
        }
    }
}

- (void)handleTapFrom: (UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint tapPoint = [tapGestureRecognizer locationInView: self];

    switch (self.type)
    {
        case MARatingViewDisplayOnly:
        {
            break;
        }
            
        case MARatingViewEditable:
        {
            MARatingViewController *ratingViewController = [[MARatingViewController alloc] initWithNibName: @"MARatingViewController" bundle: nil];

            self.popoverController = [[UIPopoverController alloc] initWithContentViewController: ratingViewController];
            
            [ratingViewController.ratingView setupWithDelegate: self
                                                        rating: self.rating
                                                          type: MARatingViewSelectable
                                                     starColor: self.starColor];

            self.popoverController.popoverContentSize = ratingViewController.view.frame.size;
            
            [self.popoverController presentPopoverFromRect: self.bounds
                                                    inView: self
                                  permittedArrowDirections: UIPopoverArrowDirectionAny
                                                  animated: YES];
            
            break;
        }
            
        case MARatingViewSelectable:
        {
            for (int star = 1; star <= 5; star = star + 1)
            {
                if (tapPoint.x >= (star - 1) * self.starWidth && tapPoint.x <= star * self.starWidth)
                {
                    self.rating = (float)star;
                }
            }

            [self setNeedsDisplay];
            
            [self.delegate ratingView: self ratingChanged: self.rating];
            break;
        }
            
        default:
        {
            NSLog(@"Rating type set to an illegal value. type = %d", (int)self.type);
            break;
        }
    }
}

- (void)ratingView: (MARatingView *)ratingView ratingChanged: (float)newRating
{
    [self.popoverController dismissPopoverAnimated: YES];

    if (newRating != self.rating)
    {
        [self.delegate ratingView: self ratingChanged: newRating];
    }
}

@end






















