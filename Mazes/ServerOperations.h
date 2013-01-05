//
//  ServerOperations.h
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@class Location;
@class Maze;
@class MazeUser;
@class Rating;
@class User;
@class Version;

@protocol MAServerOperationsGetVersionDelegate <NSObject>
@required
- (void)serverOperationsGetVersion: (Version *)version error: (NSError *)error;
@end

@protocol MAServerOperationsGetSoundsDelegate <NSObject>
@required
- (void)serverOperationsGetSounds: (NSError *)error;
@end

@protocol MAServerOperationsGetTexturesDelegate <NSObject>
@required
- (void)serverOperationsGetTextures: (NSError *)error;
@end


@protocol MAServerOperationsGetUserDelegate <NSObject>
@required
- (void)serverOperationsGetUser: (User *)user error: (NSError *)error;
@end

@protocol MAServerOperationsGetMazeDelegate <NSObject>
@required
- (void)serverOperationsGetMaze: (Maze *)maze error: (NSError *)error;
@end

@protocol MAServerOperationsGetLocationsDelegate <NSObject>
@required
- (void)serverOperationsGetLocations: (NSArray *)locations error: (NSError *)error;
@end


@protocol MAServerOperationsGetMazeUserDelegate <NSObject>
@required
- (void)serverOperationsGetMazeUser: (MazeUser *)mazeUser error: (NSError *)error;
@end

@protocol MAServerOperationsSaveMazeUserDelegate <NSObject>
@required
- (void)serverOperationsSaveMazeUserWithError: (NSError *)error;
@end

@protocol MAServerOperationsSaveMazeRatingDelegate <NSObject>
@required
- (void)serverOperationsSaveRatingWithError: (NSError *)error;
@end


@protocol MAServerOperationsHighestRatedListDelegate <NSObject>
@required
- (void)serverOperationsHighestRatedList: (NSArray *)mainListItems error: (NSError *)error;
@end

@protocol MAServerOperationsNewestListDelegate <NSObject>
@required
- (void)serverOperationsNewestList: (NSArray *)mainListItems error: (NSError *)error;
@end

@protocol MAServerOperationsYoursListDelegate <NSObject>
@required
- (void)serverOperationsYoursList: (NSArray *)mainListItems error: (NSError *)error;
@end

@interface ServerOperations : NSObject
{
    RKManagedObjectStore *managedObjectStore;
    
    RKResponseDescriptor *mainListItemResponseDescriptor;
}

+ (ServerOperations *)shared;

- (RKObjectRequestOperation *)getVersionOperationWithDelegate: (id<MAServerOperationsGetVersionDelegate>)delegate;

- (RKManagedObjectRequestOperation *)getSoundsOperationWithDelegate: (id<MAServerOperationsGetSoundsDelegate>)delegate;

- (RKManagedObjectRequestOperation *)getTexturesOperationWithDelegate: (id<MAServerOperationsGetTexturesDelegate>)delegate;


- (RKObjectRequestOperation *)getUserOperationWithDelegate: (id<MAServerOperationsGetUserDelegate>)delegate udid: (NSString *)udid;


- (RKObjectRequestOperation *)getMazeOperationWithDelegate: (id<MAServerOperationsGetMazeDelegate>)delegate mazeId: (int)mazeId;

- (RKObjectRequestOperation *)getLocationsOperationWithDelegate: (id<MAServerOperationsGetLocationsDelegate>)delegate mazeId: (int)mazeId;


- (RKObjectRequestOperation *)getMazeUserOperationWithDelegate: (id<MAServerOperationsGetMazeUserDelegate>)delegate mazeId: (int)mazeId userId: (int)userId;

- (RKObjectRequestOperation *)saveMazeUserOperationWithDelegate: (id<MAServerOperationsSaveMazeUserDelegate>)delegate mazeUser: (MazeUser *)mazeUser;

- (RKObjectRequestOperation *)saveMazeRatingOperationWithDelegate: (id<MAServerOperationsSaveMazeRatingDelegate>)delegate rating: (Rating *)rating;


- (RKObjectRequestOperation *)highestRatedOperationWithDelegate: (id<MAServerOperationsHighestRatedListDelegate>)delegate userId: (int)userId;

- (RKObjectRequestOperation *)newestOperationWithDelegate: (id<MAServerOperationsNewestListDelegate>)delegate userId: (int)userId;

- (RKObjectRequestOperation *)yoursOperationWithDelegate: (id<MAServerOperationsYoursListDelegate>)delegate userId: (int)userId;

@end





















