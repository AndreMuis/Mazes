//
//  GridView.h
//  iPad_Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Styles.h"
#import "Maze.h"
#import "Locations.h"

@interface GridView : UIView 
{
	Location *currLoc;
	Location *currWallLoc;
	int currWallDir;
}

@property (nonatomic, retain) Location *currLoc;
@property (nonatomic, retain) Location *currWallLoc;
@property (nonatomic) int currWallDir;

@end
