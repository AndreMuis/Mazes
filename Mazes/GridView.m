//
//  GridView.m
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "GridView.h"

#import "Styles.h"
#import "Maze.h"
#import "Locations.h"
#import "Location.h"

@implementation GridView

- (id)initWithCoder: (NSCoder *)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
		self.backgroundColor = [Styles shared].grid.backgroundColor;
    }
	
	return self;
}

- (void)drawRect: (CGRect)rect 
{
	[self.maze.locations drawGridWithCurrLoc: self.currLoc
                                 currWallLoc: self.currWallLoc
                                 currWallDir: self.currWallDir
                                        rows: self.maze.rows
                                     columns: self.maze.columns];
}

@end  
