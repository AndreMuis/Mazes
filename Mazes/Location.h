//
//  Location.h
//  iPad_Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface Location : NSObject 
{
	int mazeId;
	int x;
	int y;
	int direction;
	int wallNorth;
	int wallWest;
	int type;
	NSString *message;
	int teleportId;
	int teleportX;
	int teleportY;
	int wallNorthTextureId;
	int wallWestTextureId;
	int floorTextureId;
	int ceilingTextureId;
	BOOL visited;
	BOOL wallNorthHit;
	BOOL wallWestHit;
}

@property (nonatomic) int mazeId;
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int direction;
@property (nonatomic) int wallNorth;
@property (nonatomic) int wallWest;
@property (nonatomic) int type;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) int teleportId;
@property (nonatomic) int teleportX;
@property (nonatomic) int teleportY;
@property (nonatomic) int wallNorthTextureId;
@property (nonatomic) int wallWestTextureId;
@property (nonatomic) int floorTextureId;
@property (nonatomic) int ceilingTextureId;
@property (nonatomic) BOOL visited;
@property (nonatomic) BOOL wallNorthHit; 
@property (nonatomic) BOOL wallWestHit;

- (void)reset;

- (void)setWallNorthTextureIdWithNumber: (NSNumber *)textureId;
- (void)setWallWestTextureIdWithNumber: (NSNumber *)textureId;
- (void)setFloorTextureIdWithNumber: (NSNumber *)textureId;
- (void)setCeilingTextureIdWithNumber: (NSNumber *)textureId;

@end



