//
//  EditViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditViewStyle.h"

@implementation EditViewStyle

@synthesize panelBackgroundColor;
@synthesize tabDarkColor;
@synthesize tableHeaderBackgroundColor;
@synthesize tableHeaderTextColor;
@synthesize tableHeaderTextAlignment;
@synthesize tableHeaderFont;
@synthesize tableViewBackgroundColor;
@synthesize tableViewDisabledBackgroundColor;	
@synthesize tableViewBackgroundSoundRows;
@synthesize viewTexturesBackgroundColor;
@synthesize popoverTexturesWidth;
@synthesize popoverTexturesHeight;
@synthesize textureImageLength;
@synthesize texturesPerRow;
@synthesize viewButtonsBackgroundColor;
@synthesize messageBackgroundColor;
@synthesize messageTextColor;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.panelBackgroundColor = [[UIColor alloc] initWithRed: 1.0 green: 0.96 blue: 0.65 alpha: 1.0];
        self.tabDarkColor = [[UIColor alloc] initWithRed: 0.96 green: 0.87 blue: 0.0 alpha: 1.0];
        
        self.tableHeaderBackgroundColor = [Colors shared].orangeRedColor;
        self.tableHeaderTextColor = [UIColor whiteColor];
        self.tableHeaderTextAlignment = NSTextAlignmentCenter;
        self.tableHeaderFont = [UIFont boldSystemFontOfSize: 18];
        
        self.tableViewBackgroundColor = [Colors shared].whiteColor;
        self.tableViewDisabledBackgroundColor = [[UIColor alloc] initWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0]; // light gray
		
        self.tableViewBackgroundSoundRows = 4;
        
        self.viewTexturesBackgroundColor = [Colors shared].lightYellowColor;
        self.popoverTexturesWidth = 700.0;
        self.popoverTexturesHeight = 700.0;
        self.textureImageLength = 100.0;
        self.texturesPerRow = 5;
        
        self.viewButtonsBackgroundColor = [[UIColor alloc] initWithRed: 1.0 green: 0.96 blue: 0.65 alpha: 1.0]; 
        
        self.messageBackgroundColor = [Colors shared].transparentColor;
        self.messageTextColor = [Colors shared].darkBlueColor;
    }
    
    return self;
}

@end
