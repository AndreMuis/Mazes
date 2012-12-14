//
//  GameViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewStyle.h"

@implementation GameViewStyle

@synthesize titleBackgroundColor;
@synthesize titleFont;
@synthesize titleTextColor;

@synthesize helpBackgroundColor;
@synthesize helpTextColor;
@synthesize borderColor;
@synthesize messageBackgroundColor;
@synthesize messageTextColor;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.titleBackgroundColor = [Colors shared].transparentColor;
        self.titleFont = [UIFont boldSystemFontOfSize: 19];
        self.titleTextColor = [[UIColor alloc] initWithRed: 0.5 green: 0.25 blue: 0.0 alpha: 1.0]; // broen
        
        self.helpBackgroundColor = [Colors shared].lightYellowColor;
        self.helpTextColor = [Colors shared].darkBrownColor;
        
        self.borderColor = [[UIColor alloc] initWithRed: 227.0 / 256.0 green: 200.0 / 256.0 blue: 142.0 / 256.0 alpha: 1.0];
        self.messageBackgroundColor = [Colors shared].lightYellowColor;
        self.messageTextColor = [Colors shared].darkBrownColor;
    }
    
    return self;
}

@end
