//
//  MAFloorPlanViewDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAFloorPlanView;
@class MALocation;
@class MAWall;

@protocol MAFloorPlanViewDelegate <NSObject>

@required

- (void)floorPlanView: (MAFloorPlanView *)floorPlanView didSelectLocation: (MALocation *)location;

- (void)floorPlanView: (MAFloorPlanView *)floorPlanView didSelectInnerWall: (MAWall *)wall;

@end
