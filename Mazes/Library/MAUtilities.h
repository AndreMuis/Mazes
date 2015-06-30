//
//  MAUtilities.h
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <mach/mach.h>

#import <UIKit/UIKit.h>

@class MAFloorPlanStyle;

@interface MAUtilities : NSObject 

+ (void)logWithClass: (Class)class message: (NSString *)message parameters: (NSDictionary *)parameters;

+ (id)objectOrNull: (id)object;

+ (float)getAppMemoryUsageInMB;

+ (double)radiansFromDegrees: (double)degrees;
+ (double)degreesFromRadians: (double)radians;

+ (void)drawArrowInRect: (CGRect)rect angleDegrees: (double)angle scale: (float)scale;

@end
