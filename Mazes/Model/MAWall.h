//
//  MAWall.h
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAConstants.h"

typedef enum : NSUInteger
{
    MAWallUnknown = 0,
	MAWallNone = 1,
	MAWallBorder = 2,
	MAWallSolid = 3,
	MAWallInvisible = 4,
	MAWallFake = 5
} MAWallType;

@class MACoordinate;

@interface MAWall : NSObject <NSCoding>

@property (readwrite, strong, nonatomic) MACoordinate *coordinate;
@property (readwrite, assign, nonatomic) MADirectionType direction;
@property (readwrite, assign, nonatomic) MAWallType type;
@property (readwrite, strong, nonatomic) NSString *textureId;

@property (readonly, assign, nonatomic) NSUInteger row;
@property (readonly, assign, nonatomic) NSUInteger column;

@property (readwrite, assign, nonatomic) BOOL hit;
@property (readwrite, assign, nonatomic) CGRect mapRect;
@property (readwrite, strong, nonatomic) UIColor *mapColor;

@end
