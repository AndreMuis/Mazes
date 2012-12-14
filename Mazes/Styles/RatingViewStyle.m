//
//  RatingViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingViewStyle.h"

@implementation RatingViewStyle

@synthesize popupBackgroundColor;
@synthesize displayAvgColor;
@synthesize displayUserColor;
@synthesize recordPopoverColor;
@synthesize recordEndColor;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.popupBackgroundColor = [Colors shared].lightYellowColor;
        self.displayAvgColor = [Colors shared].redColor;
        self.displayUserColor = [Colors shared].blueColor;
        self.recordPopoverColor = [Colors shared].blueColor;
        self.recordEndColor = [Colors shared].yellowColor;
    }
  
    return self;
}

@end
