//
//  Styles.m
//  iPad_Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Styles.h"

@implementation Styles

@synthesize defaultFont;

@synthesize activityView;
@synthesize bannerView;
@synthesize editView;
@synthesize endAlertView;
@synthesize gameView;
@synthesize grid;
@synthesize map;
@synthesize mazeList;
@synthesize ratingView;
@synthesize screen;

- (id)init
{
    self = [super init];
	
	if (self) 
	{
        defaultFont = [UIFont systemFontOfSize: [UIFont labelFontSize]];

        self.activityView = [[ActivityViewStyle alloc] init];
        self.bannerView = [[BannerViewStyle alloc] init];
        self.editView = [[EditViewStyle alloc] init];
        self.endAlertView = [[EndAlertViewStyle alloc] init];
        self.gameView = [[GameViewStyle alloc] init];
        self.grid = [[GridStyle alloc] init];
        self.map = [[MapStyle alloc] init];
        self.mazeList = [[MazeListStyle alloc] init];
        self.ratingView = [[RatingViewStyle alloc] init];
        self.screen = [[ScreenStyle alloc] init];
    }
	
    return self;
}

+ (Styles *)instance  
{
	static Styles *instance = nil;
	
	@synchronized(self) 
	{
		if (instance == nil) 
		{
			instance = [[Styles alloc] init];
		}
	}
	
	return instance;
}

@end
