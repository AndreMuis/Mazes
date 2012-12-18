//
//  Globals.m
//  iPad_Mazes
//
//  Created by Andre Muis on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Globals.h"

#import "AppDelegate.h"
#import "WebServices.h"
#import "Maze.h"
#import "MainListViewController.h"
#import "GameViewController.h"
#import "CreateViewController.h"
#import "EditViewController.h"

@implementation Globals

+ (Globals *)shared
{
	static Globals *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[Globals alloc] init];
		}
	}
	
	return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        _mazeMain = nil;
    }
    
    return self;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (Maze *)mazeMain
{
    if (_mazeMain == nil)
    {
        _mazeMain = [[Maze alloc] init];
    }
    
    return _mazeMain;
}

- (Maze *)mazeEdit
{
    if (_mazeEdit == nil)
    {
        _mazeEdit = [[Maze alloc] init];
    }
    
    return _mazeEdit;
}

- (GameViewController *)gameViewController
{
    if (_gameViewController == nil)
    {
        _gameViewController = [[GameViewController alloc] initWithNibName: @"GameViewController" bundle: nil];
    }
    
    return _gameViewController;
}

- (CreateViewController *)createViewController
{
    if (_createViewController == nil)
    {
        _createViewController = [[CreateViewController alloc] initWithNibName: @"CreateViewController" bundle: nil];
    }
    
    return _createViewController;
}

- (EditViewController *)editViewController
{
    if (_editViewController == nil)
    {
        _editViewController = [[EditViewController alloc] initWithNibName: @"EditViewController" bundle: nil];
    }
    
    return _editViewController;
}

@end































