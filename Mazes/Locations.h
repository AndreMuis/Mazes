//
//  Locations.h
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "Location.h"
#import "Styles.h"
#import "Utilities.h"

typedef enum
{
	MAMazeObjectLocation = 1,
	MAMazeObjectWallNorth = 2,
	MAMazeObjectWallWest = 3,
	MAMazeObjectCorner = 4
} MAMazeObjectType;

@interface Locations : NSObject 
{
    NSMutableArray *list;
}

- (void)populateWithRows: (int)rows columns: (int)columns;

- (void)populateWithArray: (NSArray *)locations;

- (NSArray *)all;

- (void)removeAll;

- (void)updateMazeId: (int)mazeId;

- (Location *)getLocationByX: (int)x y: (int)y;
- (Location *)getLocationByAction: (MALocationActionType)action;

- (BOOL)isSurroundedByWallsLocation: (Location *)location;

- (MAWallType)getWallTypeLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction;
- (BOOL)hasHitWallAtLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction;

- (BOOL)isInnerWallWithLocation: (Location *)location rows: (int)rows columns: (int)columns wallDir: (MADirectionType)wallDir;

- (void)setWallTypeLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction type: (MAWallType)type;
- (void)setWallHitLocX: (int)locX locY: (int)locY direction: (MADirectionType)direction;


- (void)drawGridWithCurrLoc: (Location *)currLoc currWallLoc: (Location *)currWallLoc currWallDir: (MADirectionType)currWallDir rows: (int)rows columns: (int)columns;

- (Location *)getGridLocationFromTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns;
- (Location *)getGridWallLocationSegType: (MAMazeObjectType *)segType fromTouchPoint: (CGPoint)touchPoint rows: (int)rows columns: (int)columns;

- (CGRect)getSegmentRectFromLocation: (Location *)location segmentType: (MAMazeObjectType)segmentType;

@end
