//
//  Maze.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Locations.h"

@interface Maze : NSObject
{
	int mazeId;
	NSString *name;
	int rows;
	int columns;
	BOOL isPublic;
	int backgroundSoundId;
	int wallTextureId;
	int floorTextureId;
	int ceilingTextureId;
		
	Locations *locations;
}

@property (nonatomic) int mazeId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) int rows;
@property (nonatomic) int columns;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) int backgroundSoundId;
@property (nonatomic) int wallTextureId;
@property (nonatomic) int floorTextureId;
@property (nonatomic) int ceilingTextureId;

@property (nonatomic, retain) Locations *locations;

//- (void)populateFromXML: (xmlDocPtr)doc;

- (void)reset;

- (void)setWallTextureIdWithNumber: (NSNumber *)textureId;
- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId;
- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId;

@end
