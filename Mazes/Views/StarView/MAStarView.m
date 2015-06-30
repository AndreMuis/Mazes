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

@property (readonly, strong, nonatomic) id<MAStarViewDelegate> delegate;

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
    [self drawStar];
    
    [self drawClippingRect];
    
    [self drawOutline];
}

- (void)drawStar
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGLayerRef layer = CGLayerCreateWithContext(context, self.bounds.size, NULL);
    
    CGContextRef starContext = CGLayerGetContext(layer);
    
    CGContextSetFillColorWithColor(starContext, self.color.CGColor);
    
    [self drawStarPathWithContext: starContext];

    CGContextFillPath(starContext);
    
    CGContextDrawLayerAtPoint(context, CGPointZero, layer);
}

- (void)drawClippingRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGSize clippingRectSize = CGSizeMake(CGRectGetWidth(self.bounds),
                                         CGRectGetHeight(self.bounds));
    
    CGLayerRef layer = CGLayerCreateWithContext(context, clippingRectSize, NULL);
    
    CGContextRef clippingRectContext = CGLayerGetContext(layer);
    
    CGContextAddRect(clippingRectContext, CGRectMake(self.fillPercent * clippingRectSize.width,
                                                     0.0,
                                                     (1.0 - self.fillPercent) * clippingRectSize.width,
                                                     clippingRectSize.height));
    
    CGContextClip(clippingRectContext);
    
    CGContextDrawLayerAtPoint(context, CGPointZero, layer);
}

- (void)drawOutline
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGLayerRef layer = CGLayerCreateWithContext(context, self.bounds.size, NULL);
    
    CGContextRef outlineContext = CGLayerGetContext(layer);
    
    CGContextSetLineWidth(outlineContext, self.outlineWidth);
    CGContextSetStrokeColorWithColor(outlineContext, self.color.CGColor);
    
    [self drawStarPathWithContext: outlineContext];
    
    CGContextStrokePath(outlineContext);
    
    CGContextDrawLayerAtPoint(context, CGPointZero, layer);
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

















