//
//  Styles.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "Styles.h"

@implementation Styles

+ (Styles *)shared
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

- (id)init
{
    self = [super init];
	
	if (self) 
	{
        _defaultFont = [UIFont systemFontOfSize: [UIFont labelFontSize]];

        _activityView = [[ActivityViewStyle alloc] init];
        _editView = [[EditViewStyle alloc] init];
        _endAlertView = [[EndAlertViewStyle alloc] init];
        _gameView = [[GameViewStyle alloc] init];
        _grid = [[GridStyle alloc] init];
        _mainView = [[MainViewStyle alloc] init];
        _map = [[MapStyle alloc] init];
        _mainListView = [[MainListViewStyle alloc] init];
        _ratingView = [[RatingViewStyle alloc] init];
    }
	
    return self;
}

@end
