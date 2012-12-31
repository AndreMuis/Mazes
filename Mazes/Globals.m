//
//  Globals.m
//  Mazes
//
//  Created by Andre Muis on 1/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "Globals.h"

#import "AppDelegate.h"
#import "ServerOperations.h"
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
    }
    
    return self;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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































