//
//  Maze.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Locations.h"

@interface Maze : NSObject

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int rows;
@property (assign, nonatomic) int columns;
@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) BOOL public;
@property (assign, nonatomic) int backgroundSoundId;
@property (assign, nonatomic) int wallTextureId;
@property (assign, nonatomic) int floorTextureId;
@property (assign, nonatomic) int ceilingTextureId;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

@property (strong, nonatomic) Locations *locations;

- (void)setWallTextureIdWithNumber: (NSNumber *)textureId;
- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId;
- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId;

@end
