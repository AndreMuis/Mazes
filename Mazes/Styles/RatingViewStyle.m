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
        self.popupBackgroundColor = [Colors instance].lightYellowColor;
        self.displayAvgColor = [Colors instance].redColor;
        self.displayUserColor = [Colors instance].blueColor;
        self.recordPopoverColor = [Colors instance].blueColor;
        self.recordEndColor = [Colors instance].yellowColor;
    }
  
    return self;
}

@end
