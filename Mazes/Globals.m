//
//  Globals.m
//  iPad_Mazes
//
//  Created by Andre Muis on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Globals.h"

#import "AppDelegate.h"
#import "DataAccess.h"
#import "Maze.h"
#import "TopListsViewController.h"
#import "GameViewController.h"
#import "CreateViewController.h"
#import "EditViewController.h"

@implementation Globals

@synthesize appDelegate;
@synthesize dataAccess;
@synthesize mazeMain; 
@synthesize mazeEdit; 
@synthesize topListsViewController; 
@synthesize gameViewController; 
@synthesize createViewController; 
@synthesize editViewController; 
@synthesize sounds;
@synthesize textures; 
@synthesize bannerView; 
@synthesize activityView;

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        self.mazeMain = nil;
    }
    
    return self;
}

+ (Globals *)instance  
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

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (DataAccess *)dataAccess
{
    if (dataAccess == nil)
    {
        dataAccess = [[DataAccess alloc] init];
    }
    
    return dataAccess;
}

- (Maze *)mazeMain
{
    if (mazeMain == nil)
    {
        mazeMain = [[Maze alloc] init];
    }
    
    return mazeMain;
}

- (Maze *)mazeEdit
{
    if (mazeEdit == nil)
    {
        mazeEdit = [[Maze alloc] init];
    }
    
    return mazeEdit;
}

- (TopListsViewController *)topListsViewController
{
    return (TopListsViewController *)[self.appDelegate.navigationController.viewControllers objectAtIndex: 0];
}

- (GameViewController *)gameViewController
{
    if (gameViewController == nil)
    {
        gameViewController = [[GameViewController alloc] initWithNibName: @"GameViewController" bundle: nil];
    }
    
    return gameViewController;
}

- (CreateViewController *)createViewController
{
    if (createViewController == nil)
    {
        createViewController = [[CreateViewController alloc] initWithNibName: @"CreateViewController" bundle: nil];
    }
    
    return createViewController;
}

- (EditViewController *)editViewController
{
    if (editViewController == nil)
    {
        editViewController = [[EditViewController alloc] initWithNibName: @"EditViewController" bundle: nil];
    }
    
    return editViewController;
}

- (ADBannerView *)bannerView
{
    if (bannerView == nil)
    {
        bannerView = [[ADBannerView alloc] initWithFrame: CGRectZero];
    }
    
    return bannerView;
}

@end































