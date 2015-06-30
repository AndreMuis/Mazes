//
//  MAUtilities.m
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAUtilities.h"

#import "AppDelegate.h"

@implementation MAUtilities

+ (void)logWithClass: (Class)class message: (NSString *)message parameters: (NSDictionary *)parameters
{
    NSString *classAndMessage = [NSString stringWithFormat: @"%@: %@", NSStringFromClass(class), message];
    
    #ifdef DEBUG
    NSLog(@"%@ %@", classAndMessage, parameters);
    #endif
}

+ (id)objectOrNull: (id)object
{
    if (object)
    {
        return object;
    }
    else
    {
        return [NSNull null];
    }
}

+ (float)getAppMemoryUsageInMB
{
    struct task_basic_info info;
    
    mach_msg_type_number_t size = sizeof(info);
    
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    
    if (kerr == KERN_SUCCESS )
    {
        return (float)info.resident_size / (1024.0 * 1024.0);
    }
    else
    {
        return 0.0;
    }
}

+ (double)radiansFromDegrees: (double)degrees
{
    return degrees * ((2.0 * M_PI) / 360.0);
}

+ (double)degreesFromRadians: (double)radians
{
    return radians * (360.0 / (2.0 * M_PI));
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
    
    //CGContextSetFillColorWithColor(context, floorPlanStyle.arrowColor.CGColor);
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

@end
