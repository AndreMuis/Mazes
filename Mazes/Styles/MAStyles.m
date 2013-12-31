//
//  MAStyles.m
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAStyles.h"

#import "MAActivityIndicatorStyle.h"
#import "MACanvasStyle.h"
#import "MAColors.h"
#import "MAConstants.h"
#import "MADesignScreenStyle.h"
#import "MAFoundExitPopupStyle.h"
#import "MAGameScreenStyle.h"
#import "MAMainScreenStyle.h"
#import "MAMapStyle.h"
#import "MAPopupStyle.h"
#import "MARatingPopupStyle.h"
#import "MATopMazesScreenStyle.h"

@interface MAStyles ()

@property (strong, nonatomic) MAColors *colors;

@end

@implementation MAStyles

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
	if (self) 
	{
        _colors = colors;
        
        _defaultFont = [UIFont systemFontOfSize: [UIFont labelFontSize]];
        
        _activityIndicator = [[MAActivityIndicatorStyle alloc] initWithColors: self.colors];
        _canvas = [[MACanvasStyle alloc] initWithColors: self.colors];
        _designScreen = [[MADesignScreenStyle alloc] initWithColors: self.colors];
        _foundExitPopup = [[MAFoundExitPopupStyle alloc] initWithColors: self.colors];
        _gameScreen = [[MAGameScreenStyle alloc] initWithColors: self.colors];
        _mainScreen = [[MAMainScreenStyle alloc] init];
        _map = [[MAMapStyle alloc] initWithColors: self.colors];
        _popup = [[MAPopupStyle alloc] initWithColors: colors];
        _ratingPopup = [[MARatingPopupStyle alloc] initWithColors: self.colors];
        _topMazesScreen = [[MATopMazesScreenStyle alloc] initWithColors: self.colors];
    }
	
    return self;
}

@end
