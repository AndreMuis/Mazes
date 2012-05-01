//
//  GridView.m
//  iPad_Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridView.h"

@implementation GridView

@synthesize currLoc; 
@synthesize currWallLoc; 
@synthesize currWallDir;

- (id)initWithCoder: (NSCoder *)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
		self.backgroundColor = [Styles instance].grid.backgroundColor;
    }
	
	return self;
}

- (void)drawRect: (CGRect)rect 
{
	[[Globals instance].mazeEdit.locations drawGridWithCurrLoc: currLoc 
                                                   CurrWallLoc: currWallLoc 
                                                   CurrWallDir: currWallDir 
                                                          Rows: [Globals instance].mazeEdit.rows 
                                                       Columns: [Globals instance].mazeEdit.columns];
}

@end
