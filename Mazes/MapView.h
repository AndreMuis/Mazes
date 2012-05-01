//
//  MapView.h
//  iPad_Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Utilities.h"
#import "Styles.h"
#import "Maze.h"
#import "Location.h"
#import "MapSegment.h"

@interface MapView : UIView 
{
	NSMutableArray *mapSegments;
		
	UIImageView *directionArrowImageView;
	
	Location *currLoc;
	int currDir;
}

@property (nonatomic, retain) NSMutableArray *mapSegments;

@property (nonatomic, retain) UIImageView *directionArrowImageView;

@property (nonatomic, retain) Location *currLoc;
@property (nonatomic) int currDir;

- (void)drawMap;
- (void)drawMapCornerWithLocation: (Location *)cornerLoc MapOffset: (CGPoint)mapOffset;

- (void)rotateMapCoordinatesX: (int)x Y: (int)y Dir: (int)dir RX: (int *)rx RY: (int *)ry RDir: (int *)rdir;

- (void)addMapSegmentRect: (CGRect) rect Color: (UIColor *) color;

- (void)clearMap;

@end
