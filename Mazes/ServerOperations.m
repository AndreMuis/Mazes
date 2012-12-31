//
//  ServerOperations.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "ServerOperations.h"

#import "Constants.h"
#import "Location.h"
#import "MainListItem.h"
#import "Maze.h"
#import "MazeUser.h"
#import "Sound.h"
#import "Texture.h"
#import "Utilities.h"
#import "Version.h"

@implementation ServerOperations

+ (ServerOperations *)shared
{
	static ServerOperations *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[ServerOperations alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles: nil];
        
        self->managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel: managedObjectModel];
        
        NSString *persistentStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent: @"Mazes.sqlite"];
        
        NSError *error = nil;
        
        [managedObjectStore addSQLitePersistentStoreAtPath: persistentStorePath fromSeedDatabaseAtPath: nil withConfiguration: nil options: nil error: &error];
        
        if (error != nil)
        {
            [Utilities logWithClass: [self class] format: @"Unable to add SQLite to persistent store. Error: %@", [error localizedDescription]];
        }
        
        [managedObjectStore createManagedObjectContexts];
        
        
        RKObjectMapping *mainListItemObjectMapping = [RKObjectMapping mappingForClass: [MainListItem class]];
        
        [mainListItemObjectMapping addAttributeMappingsFromDictionary:
         @{@"mazeId" : @"mazeId",
         @"mazeName" : @"mazeName",
         @"averageRating" : @"averageRating",
         @"ratingsCount" : @"ratingsCount",
         @"userStarted" : @"userStarted",
         @"userRating" : @"userRating",
         @"lastModified" : @"lastModified"}];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        
        self->mainListItemResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: mainListItemObjectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
	}
	
    return self;
}

- (RKObjectRequestOperation *)getVersionOperationWithDelegate: (id<MAServerOperationsGetVersionDelegate>)delegate
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [Version class]];
    
    [objectMapping addAttributeMappingsFromDictionary: @{@"number" : @"number"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];

    NSURL *versionURL = [Constants shared].serverBaseURL;
    versionURL = [versionURL URLByAppendingPathComponent: @"versions"];
    versionURL = [versionURL URLByAppendingPathComponent: @"1"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: versionURL];

    [request addValue: @"application/json" forHTTPHeaderField: @"Accept"];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
    {
        Version *version = [result firstObject];
        
        [delegate serverOperationsGetVersion: version error: nil];
    }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
    {
        [Utilities logWithClass: class format: @"Unable to get version from server. Error: %@", [error localizedDescription]];

        [delegate serverOperationsGetVersion: nil error: error];
    }];
    
    return objectRequestOperation;
}

- (RKManagedObjectRequestOperation *)getSoundsOperationWithDelegate: (id<MAServerOperationsGetSoundsDelegate>)delegate
{
    RKEntityMapping *soundMapping = [RKEntityMapping mappingForEntityForName: @"Sound" inManagedObjectStore: self->managedObjectStore];
    [soundMapping addAttributeMappingsFromDictionary:
     @{@"id": @"id",
     @"name": @"name",
     @"created_at" : @"createdDate",
     @"updated_at" : @"updatedDate"}];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: soundMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *soundsURL = [Constants shared].serverBaseURL;
    soundsURL = [soundsURL URLByAppendingPathComponent: @"sounds.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: soundsURL];
 
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest: request
                                                                                                          responseDescriptors: @[responseDescriptor]];
    
    managedObjectRequestOperation.managedObjectContext = self->managedObjectStore.mainQueueManagedObjectContext;
    managedObjectRequestOperation.managedObjectCache = self->managedObjectStore.managedObjectCache;
    
    Class class = [self class];
    
    [managedObjectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
    {
        [delegate serverOperationsGetSounds: nil];
    }
                                                         failure: ^(RKObjectRequestOperation *operation, NSError *error)
    {
        [Utilities logWithClass: class format: @"Unable to get sounds from server. Error: %@", [error localizedDescription]];

        [delegate serverOperationsGetSounds: error];
    }];
        
    return managedObjectRequestOperation;
}

- (RKManagedObjectRequestOperation *)getTexturesOperationWithDelegate: (id<MAServerOperationsGetTexturesDelegate>)delegate
{
    RKEntityMapping *textureMapping = [RKEntityMapping mappingForEntityForName: @"Texture" inManagedObjectStore: self->managedObjectStore];
    [textureMapping addAttributeMappingsFromDictionary:
     @{@"id" : @"id",
     @"name" : @"name",
     @"width" : @"width",
     @"height" : @"height",
     @"repeats" : @"repeats",
     @"kind" : @"kind",
     @"order" : @"order",
     @"created_at" : @"createdDate",
     @"updated_at" : @"updatedDate"}];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: textureMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *texturesURL = [Constants shared].serverBaseURL;
    texturesURL = [texturesURL URLByAppendingPathComponent: @"textures.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: texturesURL];
    
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest: request
                                                                                                          responseDescriptors: @[responseDescriptor]];
    
    managedObjectRequestOperation.managedObjectContext = self->managedObjectStore.mainQueueManagedObjectContext;
    managedObjectRequestOperation.managedObjectCache = self->managedObjectStore.managedObjectCache;
    
    Class class = [self class];
    
    [managedObjectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsGetTextures: nil];
     }
                                                         failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get textures from server. Error: %@", [error localizedDescription]];

         [delegate serverOperationsGetTextures: error];
     }];
    
    return managedObjectRequestOperation;
}


- (RKObjectRequestOperation *)getMazeOperationWithDelegate: (id<MAServerOperationsGetMazeDelegate>)delegate mazeId: (int)mazeId
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [Maze class]];
    
    [objectMapping addAttributeMappingsFromDictionary:
     @{@"id" : @"id",
     @"user_id" : @"userId",
     @"name" : @"name",
     @"rows" : @"rows",
     @"columns" : @"columns",
     @"active" : @"active",
     @"is_public" : @"public",
     @"background_sound_id" : @"backgroundSoundId",
     @"wall_texture_id" : @"wallTextureId",
     @"floor_texture_id" : @"floorTextureId",
     @"ceiling_texture_id" : @"ceilingTextureId",
     @"created_at" : @"createdDate",
     @"updated_at" : @"updatedDate"}];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"mazes/%d.json", mazeId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsGetMaze: [result firstObject] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get maze from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsGetMaze: nil error: error];
     }];
    
    return objectRequestOperation;
}

- (RKObjectRequestOperation *)getLocationsOperationWithDelegate: (id<MAServerOperationsGetLocationsDelegate>)delegate mazeId: (int)mazeId
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [Location class]];
    
    [objectMapping addAttributeMappingsFromDictionary:
    @{@"id" : @"id",
    @"maze_id" : @"mazeId",
    @"x" : @"x",
    @"y" : @"y",
    @"direction" : @"direction",
    @"wall_north" : @"wallNorth",
    @"wall_west" : @"wallWest",
    @"action" : @"action",
    @"message" : @"message",
    @"teleport_id" : @"teleportId",
    @"teleport_x" : @"teleportX",
    @"teleport_y" : @"teleportY",
    @"wall_north_texture_id" : @"wallNorthTextureId",
    @"wall_west_texture_id" : @"wallWestTextureId",
    @"floor_texture_id" : @"floorTextureId",
    @"ceiling_texture_id" : @"ceilingTextureId",
    @"created_at" : @"createdDate",
    @"updated_at" : @"updatedDate"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"mazes/%d/locations.json", mazeId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsGetLocations: [result array] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get maze from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsGetLocations: nil error: error];
     }];
    
    return objectRequestOperation;
}

- (RKObjectRequestOperation *)getMazeUserOperationWithDelegate: (id<MAServerOperationsGetMazeUserDelegate>)delegate mazeId: (int)mazeId userId: (int)userId
{    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [MazeUser class]];
    
    [objectMapping addAttributeMappingsFromDictionary:
    @{@"id" : @"id",
    @"maze_id" : @"mazeId",
    @"user_id" : @"userId",
    @"started" : @"started",
    @"finished" : @"finished",
    @"rating" : @"rating",
    @"created_at" : @"createdDate",
    @"updated_at" : @"updatedDate"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];

    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"/maze_users/show/%d/%d.json", mazeId, userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsGetMazeUser: [result firstObject] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get mazeUser from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsGetMazeUser: nil error: error];
     }];
    
    return objectRequestOperation;
}


- (RKObjectRequestOperation *)highestRatedOperationWithDelegate: (id<MAServerOperationsHighestRatedListDelegate>)delegate userId: (int)userId
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/highestRatedList/%d.json", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[self->mainListItemResponseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsHighestRatedList: [result array] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get highest rated main list items from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsHighestRatedList: nil error: error];
     }];
    
    return objectRequestOperation;
}

- (RKObjectRequestOperation *)newestOperationWithDelegate: (id<MAServerOperationsNewestListDelegate>)delegate userId: (int)userId
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/newestList/%d.json", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[self->mainListItemResponseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsNewestList: [result array] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get newest main list items from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsNewestList: nil error: error];
     }];
    
    return objectRequestOperation;
}

- (RKObjectRequestOperation *)yoursOperationWithDelegate: (id<MAServerOperationsYoursListDelegate>)delegate userId: (int)userId
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/yoursList/%d.json", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[self->mainListItemResponseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsYoursList: [result array] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get yours main list items from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsYoursList: nil error: error];
     }];
    
    return objectRequestOperation;
}

@end



























