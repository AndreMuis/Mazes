//
//  Utilities.m
//  iPad_Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#import "AppDelegate.h"
#import "Styles.h"

@implementation Utilities

+ (void)LogWithObject: (id)object Format: (NSString *)formatString, ...
{
    #ifdef DEBUG
    formatString = [NSString stringWithFormat: @"%@: %@", NSStringFromClass([object class]), formatString];
    
    va_list args;
    va_start(args, formatString);
    
    NSLogv(formatString, args);
    
    va_end(args);
    #else
    
    #endif
}

+ (NSString *)getLanguageCode
{
	NSArray *preferredLanguages = [NSLocale preferredLanguages];
	NSString *languageCode = ((preferredLanguages.count == 0) ? @"en" : [preferredLanguages objectAtIndex: 0]);

	return languageCode;
}

+ (NSString *)getLanguageNameFromCode: (NSString *)languageCode
{
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: languageCode];
	
	NSString *languageName = [locale displayNameForKey: NSLocaleLanguageCode value: languageCode];
	
	return languageName;
}

+ (void)createActivityView
{
	[Globals instance].activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [Styles instance].screen.width, [Styles instance].screen.height)];
	
	UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	
	UILabel *lblMessage = [[UILabel alloc] initWithFrame: CGRectZero];
	
	[[Globals instance].activityView addSubview: activityWheel];
	[[Globals instance].activityView addSubview: lblMessage];
}

+ (void)showActivityViewWithMessage: (NSString *)message
{
	CGSize messageSize = [message sizeWithFont: [Styles instance].activityView.messageFont];
	
	UIActivityIndicatorView *activityWheel = (UIActivityIndicatorView *)[[[Globals instance].activityView subviews] objectAtIndex: 0];

	float padding = [Styles instance].activityView.paddingPrcnt * activityWheel.frame.size.width;
	
	float wheelX = [Styles instance].screen.width / 2.0 - activityWheel.frame.size.width / 2.0 - padding / 2.0 - messageSize.width / 2.0;
	float wheelY = [Styles instance].screen.height / 2.0 - activityWheel.frame.size.height / 2.0;

	activityWheel.frame = CGRectMake(wheelX, wheelY, activityWheel.frame.size.width, activityWheel.frame.size.height); 

	UILabel *lblMessage = (UILabel *)[[[Globals instance].activityView subviews] objectAtIndex: 1];
	lblMessage.backgroundColor = [Colors instance].transparentColor;
	lblMessage.frame = CGRectMake(wheelX + activityWheel.frame.size.width + padding, wheelY + 2.0, messageSize.width, messageSize.height);
	lblMessage.font = [UIFont systemFontOfSize: 31];
	lblMessage.text = message;
	lblMessage.textColor = [Styles instance].activityView.messageColor;
	
	[[Globals instance].appDelegate.window addSubview: [Globals instance].activityView];
	
	[[[[Globals instance].activityView subviews] objectAtIndex: 0] startAnimating];
}

+ (void)hideActivityView
{
	[[[Globals instance].activityView.subviews objectAtIndex: 0] stopAnimating];

	[[Globals instance].activityView removeFromSuperview];
}

+ (void)ShowAlertWithDelegate: (id)delegate Message: (NSString *)message CancelButtonTitle: (NSString *)cancelButtonTitle OtherButtonTitle: (NSString *)otherButtonTitle Tag: (int)tag Bounds: (CGRect)bounds
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: delegate cancelButtonTitle: cancelButtonTitle otherButtonTitles: nil];
	
	if ([otherButtonTitle isEqualToString: @""] == NO)
		[alert addButtonWithTitle: otherButtonTitle];
	
	alert.tag = tag;
	
	if (CGRectEqualToRect(bounds, CGRectZero) == NO)
		alert.bounds = bounds;
	
	[alert show];	
}

+ (void)drawBorderInsideRect: (CGRect)rect WithWidth: (CGFloat)width Color: (UIColor *)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	CGContextSetFillColorWithColor(context, color.CGColor);
	
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, width));
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - width, rect.size.width, width));
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + width, width, rect.size.height - 2.0 * width));
	CGContextFillRect(context, CGRectMake(rect.origin.x + rect.size.width - width, rect.origin.y + width, width, rect.size.height - 2.0 * width));
}

+ (void)drawStarInRect: (CGRect)rect ClipRect: (CGRect)clipRect UIColor: (UIColor *)uiColor Outline: (BOOL)outline
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
		
		[self RotateX: &x1 Y: &y1 AngleDegrees: 72.0];
		[self RotateX: &x2 Y: &y2 AngleDegrees: 72.0];		
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

+ (void)RotateImageView: (UIImageView *)imageView AngleDegrees: (CGFloat)angleDegrees
{
	imageView.transform = CGAffineTransformMakeRotation(angleDegrees * (M_PI / 180.0));
}

+ (UIImage *)CreateDirectionArrowImageWidth: (CGFloat)width Height: (CGFloat)height
{
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	UIImage *directionArrowImage = [[UIImage alloc] initWithContentsOfFile: [NSString stringWithFormat:@"%@/%@", bundlePath, @"Direction Arrow.png"]];

	UIGraphicsBeginImageContext(CGSizeMake(width, height));

	[directionArrowImage drawInRect: CGRectMake(0.0, 0.0, width, height)];
	UIImage* directionArrowImageScaled = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return directionArrowImageScaled;
}

+ (void)drawArrowInRect: (CGRect)rect AngleDegrees: (double)angle Scale: (float)scale
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
	
	[self RotateX: &x1 Y: &y1 AngleDegrees: angle];
	[self RotateX: &x2 Y: &y2 AngleDegrees: angle];
	[self RotateX: &x3 Y: &y3 AngleDegrees: angle];
	[self RotateX: &x4 Y: &y4 AngleDegrees: angle];

	CGPoint origin = CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height / 2.0);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, origin.x + x1, origin.y + y1);
	CGContextAddLineToPoint(context, origin.x + x2, origin.y + y2);
	CGContextAddLineToPoint(context, origin.x + x3, origin.y + y3);
	CGContextAddLineToPoint(context, origin.x + x4, origin.y + y4);
	CGContextClosePath(context);
	
	CGContextSetFillColorWithColor(context, [Styles instance].grid.arrowColor.CGColor);	
	CGContextFillPath(context);
}

// theta = 0 east, rotation is counter-clockwise
+ (void)RotateX: (float *)x Y: (float *)y AngleDegrees: (double)dangle
{
	double angle = atan(*y / *x); 
	
	// convert from -90 - 90 to 0 - 360
	if (*x < 0.0)
		angle = angle + M_PI;
	
	if (*x > 0.0 && *y < 0.0)
		angle = angle + 2.0 * M_PI;
	
	angle = angle + [self RadiansFromDegrees: dangle];
	
	float r = sqrt(*x * *x + *y * *y);
	
	*x = r * cos(angle);
	*y = r * sin(angle);
}

+ (double)RadiansFromDegrees: (double)degrees
{
	return degrees * ((2.0 * M_PI) / 360.0);
}

+ (double)DegreesFromRadians: (double)radians
{
	return radians * (360.0 / (2.0 * M_PI));
}

+ (NSString *)URLEncode: (NSString *)string
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	
	return encodedString;
}

@end
