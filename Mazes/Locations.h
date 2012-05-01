//
//  Locations.h
//  iPad_Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utilities.h"
#import "XML.h"

#import <libxml/tree.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

#import "Styles.h"
#import "Location.h"

@interface Locations : NSObject 
{
	NSMutableArray *array;
}

@property (nonatomic, retain) NSMutableArray *array;

- (void)populateWithRows: (int)rows Columns: (int)columns;
- (void)populateWithXML: (xmlDocPtr)xml;

- (void)reset;

- (void)UpdateMazeId: (int)mazeId;

- (Location *)getLocationByX: (int)x Y: (int)y;
- (Location *)getLocationByType: (int)type;

- (BOOL)IsSurroundedByWallsLocation: (Location *)location;

- (int)getWallTypeLocX: (int)locX LocY: (int)locY Direction: (int)direction;
- (BOOL)hasHitWallAtLocX: (int)locX LocY: (int)locY Direction: (int)direction;

- (BOOL)IsInnerWallWithLocation: (Location *)location Rows: (int)rows Columns: (int)columns WallDir: (int)wallDir;

- (void)setWallTypeLocX: (int)locX LocY: (int)locY Direction: (int)direction Type: (int)type;
- (void)setWallHitLocX: (int)locX LocY: (int)locY Direction: (int)direction;


- (void)drawGridWithCurrLoc: (Location *)currLoc CurrWallLoc: (Location *)currWallLoc CurrWallDir: (int)currWallDir Rows: (int)rows Columns: (int)columns;

- (Location *)getGridLocationFromTouchPoint: (CGPoint)touchPoint Rows: (int)rows Columns: (int)columns;
- (Location *)getGridWallLocationSegType: (int *)segType FromTouchPoint: (CGPoint)touchPoint Rows: (int)rows Columns: (int)columns;

- (CGRect)getSegmentRectFromLocation: (Location *)location SegmentType: (int)segmentType;


- (xmlNodePtr)CreateLocationsXMLWithDoc: (xmlDocPtr)doc;

@end
