//
//  MAStarView.m
//  Mazes
//
//  Created by Andre Muis on 6/29/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAStarView.h"

#import "MAConstants.h"
#import "MAStarViewDelegate.h"

@interface MAStarView ()

@property (readonly, weak, nonatomic) id<MAStarViewDelegate> delegate;

@property (readonly, strong, nonatomic) UIColor *color;
@property (readonly, assign, nonatomic) float fillPercent;
@property (readonly, assign, nonatomic) float cuspRadiusAsPercentOfTipRadius;
@property (readonly, assign, nonatomic) float outlineWidth;

@end

@implementation MAStarView

- (void)setupWithDelegate: (id<MAStarViewDelegate>)delegate
                    color: (UIColor *)color
              fillPercent: (CGFloat)fillPercent
             outlineWidth: (CGFloat)outlineWidth
{
    _delegate = delegate;
    
    _color = color;
    _fillPercent = fillPercent;
    _cuspRadiusAsPercentOfTipRadius = MSStarCuspRadiusAsPercentOfTipRadius;
    _outlineWidth = outlineWidth;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(tapped:)];
    
    [self addGestureRecognizer: tapGestureRecognizer];
    
    [self setNeedsDisplay];
}

- (void)drawRect: (CGRect)rect
{
    [self drawClippedStar];
    
    [self drawOutline];
}

- (void)drawClippedStar
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.fillPercent < 1.0)
    {
        CGContextSaveGState(context);
    
        CGRect clippingRect = CGRectMake(0.0,
                                         0.0,
                                         self.fillPercent * self.bounds.size.width,
                                         self.bounds.size.height);

        CGContextClipToRect(context, clippingRect);
    }
        
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    
    [self drawStarPathWithContext: context];
    
    CGContextFillPath(context);
    
    if (self.fillPercent < 1.0)
    {
        CGContextRestoreGState(context);
    }
}

- (void)drawOutline
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, self.outlineWidth);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    
    [self drawStarPathWithContext: context];
    
    CGContextStrokePath(context);
}

- (void)drawStarPathWithContext: (CGContextRef)context
{
    CGFloat tipDeltaAngle = (2.0 * M_PI) / 5.0;
    
    float tipRadius = 0.0;
    
    if (CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds))
    {
        tipRadius = CGRectGetWidth(self.bounds) / 2.0;
    }
    else
    {
        tipRadius = CGRectGetHeight(self.bounds) / 2.0;
    }
    
    float cuspRadius = self.cuspRadiusAsPercentOfTipRadius * tipRadius;

    CGFloat verticalDisplacement = (CGRectGetHeight(self.bounds) / 2.0 - tipRadius * cos(tipDeltaAngle / 2.0)) / 2.0;
    
    CGPoint starOrigin = CGPointMake(CGRectGetWidth(self.bounds) / 2.0,
                                     CGRectGetHeight(self.bounds) / 2.0 + verticalDisplacement);

    CGContextBeginPath(context);

    CGContextMoveToPoint(context,
                         starOrigin.x,
                         starOrigin.y + (-1.0 * tipRadius));

    float radius = 0.0;
    NSUInteger count = 0;
    float x = 0.0;
    float y = 0.0;

    for (float theta = 0.0; theta <= 2.0 * M_PI; theta = theta + tipDeltaAngle / 2.0)
    {
        count = (NSUInteger)round(theta / (tipDeltaAngle / 2.0));
        
        if (count % 2 == 0)
        {
            radius = tipRadius;
        }
        else
        {
            radius = cuspRadius;
        }
        
        x = radius * sin(theta);
        y = radius * cos(theta);
        
        CGContextAddLineToPoint(context,
                                starOrigin.x + x,
                                starOrigin.y + (-1.0 * y));
    }

    CGContextClosePath(context);
}

- (IBAction)tapped: (UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate starViewDidTap: self];
}

@end

















