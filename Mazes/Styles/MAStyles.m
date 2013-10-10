//
//  MAStyles.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAStyles.h"

#import "MAActivityViewStyle.h"
#import "MAColors.h"
#import "MAConstants.h"
#import "MAEditViewStyle.h"
#import "MAEndAlertViewStyle.h"
#import "MAGameViewStyle.h"
#import "MAGridStyle.h"
#import "MAMainListViewStyle.h"
#import "MAMainViewStyle.h"
#import "MAMapStyle.h"
#import "MARatingViewStyle.h"

@interface MAStyles ()

@property (strong, nonatomic) MAColors *colors;
@property (strong, nonatomic) MAConstants *constants;

@end

@implementation MAStyles

- (id)initWithConstants: (MAConstants *)constants colors: (MAColors *)colors
{
    self = [super init];
	
	if (self) 
	{
        _colors = colors;
        _constants = constants;
        
        _defaultFont = [UIFont systemFontOfSize: [UIFont labelFontSize]];
        
        _activityView = [[MAActivityViewStyle alloc] initWithColors: self.colors];
        _editView = [[MAEditViewStyle alloc] initWithColors: self.colors];
        _endAlertView = [[MAEndAlertViewStyle alloc] initWithColors: self.colors];
        _gameView = [[MAGameViewStyle alloc] initWithColors: self.colors];
        _grid = [[MAGridStyle alloc] initWithColors: self.colors];
        _mainView = [[MAMainViewStyle alloc] init];
        _map = [[MAMapStyle alloc] initWithConstants: self.constants colors: self.colors];
        _mainListView = [[MAMainListViewStyle alloc] initWithColors: self.colors];
        _ratingView = [[MARatingViewStyle alloc] initWithColors: self.colors];
    }
	
    return self;
}

@end
