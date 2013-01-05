//
//  Utilities.m
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "Utilities.h"

#import "AppDelegate.h"
#import "Styles.h"

@implementation Utilities

+ (void)logWithClass: (Class)class format: (NSString *)formatString, ...
{
    NSString *newFormatString = [NSString stringWithFormat: @"%@: %@", NSStringFromClass(class), formatString];
    
    
    va_list args;
    va_start(args, formatString);
    
    NSString *message = [[NSString alloc] initWithFormat: newFormatString arguments: args];
    
    va_end(args);
    
    
    #ifdef DEBUG
    
    NSLog(@"%@", message);
    
    #else
    
    [Flurry logEvent: @"Log message" withParameters: [NSDictionary dictionaryWithObjectsAndKeys:
                                                      message, @"message",
                                                      nil]];
    
    #endif
}

+ (BOOL)iCloudAvavilable
{
    NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier: nil];
    
    if (url != nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)cleariCloudStore
{
    for (NSString *key in [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].allKeys)
    {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey: key];
    }
}

+ (void)drawBorderInsideRect: (CGRect)rect withWidth: (CGFloat)width color: (UIColor *)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	CGContextSetFillColorWithColor(context, color.CGColor);
	
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, width));
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - width, rect.size.width, width));
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + width, width, rect.size.height - 2.0 * width));
	CGContextFillRect(context, CGRectMake(rect.origin.x + rect.size.width - width, rect.origin.y + width, width, rect.size.height - 2.0 * width));
}

+ (void)drawStarInRect: (CGRect)rect clipRect: (CGRect)clipRect color: (UIColor *)uiColor outline: (BOOL)outline
{
	CGContextRef context = UIGraphicsGetCurrentContext();	

	// save and reset graphic context to undo clipping
	CGContextSaveGState(context);
	
	if (CGRectEqualToRect(clipRect, CGRectZero) == NO)
		CGContextClipToRect(context, clipRect);
	
	// arm length can't be rect.size.height / 2 because we want to fit the star in a rectangle, not a circle
	float armLength = 0.553 * rect.size.height;

	CGPoint origin = CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + armLength);
	
	// reduce arm length so star will fit in rect
	if (outline == YES)
		armLength = armLength * 0.84;
	else 
		armLength = armLength * 0.98;
	
	CGContextSetLineWidth(context, 1.0);
	
	CGContextBeginPath(context);
	
	float x1 = 0.0;
	float y1 = armLength;
	
	float x2 = -0.225 * armLength;
	float y2 = 0.309 * armLength;
	
	for (int i = 1; i <= 5; i = i + 1)
	{
		if (i == 1)
		{
			CGContextMoveToPoint(context, origin.x + x1, origin.y - y1);
			CGContextAddLineToPoint(context, origin.x + x2, origin.y - y2);
		}
		else 
		{
			CGContextAddLineToPoint(context, origin.x + x1, origin.y - y1);
			CGContextAddLineToPoint(context, origin.x + x2, origin.y - y2);				
		}
		
		[self rotateX: &x1 y: &y1 angleDegrees: 72.0];
		[self rotateX: &x2 y: &y2 angleDegrees: 72.0];
	}
	
	CGContextClosePath(context);
	
	if (outline == YES)
	{
		CGContextSetStrokeColorWithColor(context, uiColor.CGColor);	
		
		CGContextStrokePath(context);
	}
	else 
	{
		CGContextSetFillColorWithColor(context, uiColor.CGColor);	
				
		CGContextFillPath(context);
	}
	
	CGContextRestoreGState(context);
}

+ (void)rotateImageView: (UIImageView *)imageView angleDegrees: (CGFloat)angleDegrees
{
	imageView.transform = CGAffineTransformMakeRotation(angleDegrees * (M_PI / 180.0));
}

+ (UIImage *)createDirectionArrowImageWidth: (CGFloat)width height: (CGFloat)height
{
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	UIImage *directionArrowImage = [[UIImage alloc] initWithContentsOfFile: [NSString stringWithFormat:@"%@/%@", bundlePath, @"Direction Arrow.png"]];

	UIGraphicsBeginImageContext(CGSizeMake(width, height));

	[directionArrowImage drawInRect: CGRectMake(0.0, 0.0, width, height)];
	UIImage* directionArrowImageScaled = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return directionArrowImageScaled;
}

+ (void)drawArrowInRect: (CGRect)rect angleDegrees: (double)angle scale: (float)scale
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	float x1 = -rect.size.width / 2.0;
	float y1 = rect.size.height / 2.0;
	
	float x2 = 0.0;
	float y2 = -rect.size.height / 2.0;
	
	float x3 = rect.size.width / 2.0;
	float y3 = rect.size.height / 2.0;

	float x4 = 0.0;
	float y4 = rect.size.height / 3.7;

	x1 = x1 * scale;
	y1 = y1 * scale;
	
	x2 = x2 * scale;
	y2 = y2 * scale;
	
	x3 = x3 * scale;
	y3 = y3 * scale;
	
	x4 = x4 * scale;
	y4 = y4 * scale;
	
	[self rotateX: &x1 y: &y1 angleDegrees: angle];
	[self rotateX: &x2 y: &y2 angleDegrees: angle];
	[self rotateX: &x3 y: &y3 angleDegrees: angle];
	[self rotateX: &x4 y: &y4 angleDegrees: angle];

	CGPoint origin = CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height / 2.0);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, origin.x + x1, origin.y + y1);
	CGContextAddLineToPoint(context, origin.x + x2, origin.y + y2);
	CGContextAddLineToPoint(context, origin.x + x3, origin.y + y3);
	CGContextAddLineToPoint(context, origin.x + x4, origin.y + y4);
	CGContextClosePath(context);
	
	CGContextSetFillColorWithColor(context, [Styles shared].grid.arrowColor.CGColor);
	CGContextFillPath(context);
}

// theta = 0 east, rotation is counter-clockwise
+ (void)rotateX: (float *)x y: (float *)y angleDegrees: (double)dangle
{
	double angle = atan(*y / *x); 
	
	// convert from -90 - 90 to 0 - 360
	if (*x < 0.0)
		angle = angle + M_PI;
	
	if (*x > 0.0 && *y < 0.0)
		angle = angle + 2.0 * M_PI;
	
	angle = angle + [self radiansFromDegrees: dangle];
	
	float r = sqrt(*x * *x + *y * *y);
	
	*x = r * cos(angle);
	*y = r * sin(angle);
}

+ (double)radiansFromDegrees: (double)degrees
{
	return degrees * ((2.0 * M_PI) / 360.0);
}

+ (double)degreesFromRadians: (double)radians
{
	return radians * (360.0 / (2.0 * M_PI));
}

@end
