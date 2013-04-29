//
//  ServerOperations.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "ServerOperations.h"

#import "Constants.h"
#import "Locations.h"
#import "Location.h"
#import "MainListItem.h"
#import "Maze.h"
#import "MazeUser.h"
#import "Rating.h"
#import "Sound.h"
#import "Texture.h"
#import "User.h"
#import "Utilities.h"
#import "Version.h"

@interface ServerOperations ()

@property (strong, nonatomic) RKManagedObjectStore *managedObjectStore;
@property (strong, nonatomic) RKResponseDescriptor *mainListItemResponseDescriptor;

@end

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
        
        self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel: managedObjectModel];
        
        NSString *persistentStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent: @"Mazes.sqlite"];
        
        NSError *error = nil;
        
        [self.managedObjectStore addSQLitePersistentStoreAtPath: persistentStorePath fromSeedDatabaseAtPath: nil withConfiguration: nil options: nil error: &error];
        
        if (error != nil)
        {
            [Utilities logWithClass: [self class] format: @"Unable to add SQLite to persistent store. Error: %@", [error localizedDescription]];
        }
        
        [self.managedObjectStore createManagedObjectContexts];
        
        
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
        
        self.mainListItemResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: mainListItemObjectMapping
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
    RKEntityMapping *soundMapping = [RKEntityMapping mappingForEntityForName: @"Sound" inManagedObjectStore: self.managedObjectStore];
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
    
    managedObjectRequestOperation.managedObjectContext = self.managedObjectStore.mainQueueManagedObjectContext;
    managedObjectRequestOperation.managedObjectCache = self.managedObjectStore.managedObjectCache;
    
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
    RKEntityMapping *textureMapping = [RKEntityMapping mappingForEntityForName: @"Texture" inManagedObjectStore: self.managedObjectStore];
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
    
    managedObjectRequestOperation.managedObjectContext = self.managedObjectStore.mainQueueManagedObjectContext;
    managedObjectRequestOperation.managedObjectCache = self.managedObjectStore.managedObjectCache;
    
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


- (RKObjectRequestOperation *)getUserOperationWithDelegate: (id<MAServerOperationsGetUserDelegate>)delegate udid: (NSString *)udid
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [User class]];
    
    [objectMapping addAttributeMappingsFromDictionary:
     @{@"id" : @"id",
     @"udid" : @"udid",
     @"created_at" : @"createdDate",
     @"updated_at" : @"updatedDate"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"/users/show/%@.json", udid]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsGetUser: [result firstObject] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get user from server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsGetUser: nil error: error];
     }];
    
    return objectRequestOperation;
}


- (RKObjectRequestOperation *)getMazeOperationWithDelegate: (id<MAServerOperationsGetMazeDelegate>)delegate mazeId: (int)mazeId
{
    RKObjectMapping *mazeObjectMapping = [RKObjectMapping mappingForClass: [Maze class]];
    
    [mazeObjectMapping addAttributeMappingsFromDictionary:
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

    
    RKObjectMapping *locationObjectMapping = [RKObjectMapping mappingForClass: [Location class]];
    
    [locationObjectMapping addAttributeMappingsFromDictionary:
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

    [mazeObjectMapping addPropertyMapping: [RKRelationshipMapping relationshipMappingFromKeyPath: @"locations"
                                                                                       toKeyPath: @"locations.list"
                                                                                     withMapping: locationObjectMapping]];

    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: mazeObjectMapping
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

- (RKObjectRequestOperation *)getMazeOperationWithDelegate: (id<MAServerOperationsGetMazeDelegate>)delegate userId: (int)userId
{
    RKObjectMapping *mazeObjectMapping = [RKObjectMapping mappingForClass: [Maze class]];
    
    [mazeObjectMapping addAttributeMappingsFromDictionary:
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
    
    
    RKObjectMapping *locationObjectMapping = [RKObjectMapping mappingForClass: [Location class]];
    
    [locationObjectMapping addAttributeMappingsFromDictionary:
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
    
    [mazeObjectMapping addPropertyMapping: [RKRelationshipMapping relationshipMappingFromKeyPath: @"locations"
                                                                                       toKeyPath: @"locations.list"
                                                                                     withMapping: locationObjectMapping]];

    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: mazeObjectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"mazes/show/%d.json", userId]];
    
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

- (RKObjectRequestOperation *)saveMazeOperationWithDelegate: (id<MAServerOperationsSaveMazeDelegate>)delegate maze: (Maze *)maze
{
    // Request
    
    NSMutableDictionary *mazeDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNumber numberWithInt: maze.userId], @"user_id",
                                           maze.name, @"name",
                                           [NSNumber numberWithInt: maze.rows], @"rows",
                                           [NSNumber numberWithInt: maze.columns], @"columns",
                                           [NSNumber numberWithBool: maze.active], @"active",
                                           [NSNumber numberWithBool: maze.public], @"is_public",
                                           [NSNumber numberWithInt: maze.backgroundSoundId], @"background_sound_id",
                                           [NSNumber numberWithInt: maze.wallTextureId], @"wall_texture_id",
                                           [NSNumber numberWithInt: maze.floorTextureId], @"floor_texture_id",
                                           [NSNumber numberWithInt: maze.ceilingTextureId], @"ceiling_texture_id",
                                           nil];
    
    if (maze.id != 0)
    {
        [mazeDictionary setObject: [NSNumber numberWithInt: maze.id] forKey: @"id"];
    }
    
    
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];

    for (Location *location in maze.locations.list)
    {
        NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   [NSNumber numberWithInt: location.x], @"x",
                                                   [NSNumber numberWithInt: location.y], @"y",
                                                   [NSNumber numberWithInt: location.direction], @"direction",
                                                   [NSNumber numberWithInt: location.wallNorth], @"wall_north",
                                                   [NSNumber numberWithInt: location.wallWest], @"wall_west",
                                                   [NSNumber numberWithInt: location.action], @"action",
                                                   location.message, @"message",
                                                   [NSNumber numberWithInt: location.teleportId], @"teleport_id",
                                                   [NSNumber numberWithInt: location.teleportX], @"teleport_x",
                                                   [NSNumber numberWithInt: location.teleportY], @"teleport_y",
                                                   [NSNumber numberWithInt: location.wallNorthTextureId], @"wall_north_texture_id",
                                                   [NSNumber numberWithInt: location.wallWestTextureId], @"wall_west_texture_id",
                                                   [NSNumber numberWithInt: location.floorTextureId], @"floor_texture_id",
                                                   [NSNumber numberWithInt: location.ceilingTextureId], @"ceiling_texture_id",
                                                   nil];
        
        if (maze.id != 0)
        {
            [locationDictionary setObject: [NSNumber numberWithInt: location.id] forKey: @"id"];
            [locationDictionary setObject: [NSNumber numberWithInt: location.mazeId] forKey: @"maze_id"];
        }

        [locationsArray addObject: locationDictionary];
    }

    [mazeDictionary setObject: locationsArray forKey: @"locations_attributes"];


    NSError *error = nil;
    NSData *requestBody = [RKMIMETypeSerialization dataFromObject: @{@"maze" : mazeDictionary}
                                                         MIMEType: RKMIMETypeJSON
                                                            error: &error];
    
    
    if (error != nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to serialize parameters. Error = %@", [error localizedDescription]];
    }
    
    
    NSURL *url = [Constants shared].serverBaseURL;
    if (maze.id == 0)
    {
        url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"/mazes.json"]];
    }
    else
    {
        url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"/mazes/%d.json", maze.id]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    if (maze.id == 0)
    {
        [request setHTTPMethod: @"POST"];
    }
    else
    {
        [request setHTTPMethod: @"PUT"];
    }
    
    [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody: requestBody];
    
    // Response
    
    RKObjectMapping *mazeObjectMapping = [RKObjectMapping mappingForClass: [Maze class]];
    
    [mazeObjectMapping addAttributeMappingsFromDictionary:
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
    
    
    RKObjectMapping *locationObjectMapping = [RKObjectMapping mappingForClass: [Location class]];
    
    [locationObjectMapping addAttributeMappingsFromDictionary:
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
    
    [mazeObjectMapping addPropertyMapping: [RKRelationshipMapping relationshipMappingFromKeyPath: @"locations"
                                                                                       toKeyPath: @"locations.list"
                                                                                     withMapping: locationObjectMapping]];
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: mazeObjectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    // Response end
    
    NSArray *responseDescriptors = nil;
    if (maze.id == 0)
    {
        responseDescriptors = @[responseDescriptor];
    }
    else
    {
        responseDescriptors = @[];
    }
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: responseDescriptors];
    
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsSaveMaze: [result firstObject] error: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to save maze on server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsSaveMaze: nil error: error];
     }];
    
    return objectRequestOperation;
}

- (RKObjectRequestOperation *)deleteMazeOperationWithDelegate: (id<MAServerOperationsDeleteMazeDelegate>)delegate mazeId: (int)mazeId
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"mazes/%d.json", mazeId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    [request setHTTPMethod: @"DELETE"];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[]];
    
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsDeleteMazeWithError: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to set rating on server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsDeleteMazeWithError: error];
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

- (RKObjectRequestOperation *)saveMazeUserOperationWithDelegate: (id<MAServerOperationsSaveMazeUserDelegate>)delegate mazeUser: (MazeUser *)mazeUser
{
    NSDictionary *mazeUserDictionary =
    @{@"maze_id" : [NSNumber numberWithInt: mazeUser.mazeId],
    @"user_id" : [NSNumber numberWithInt: mazeUser.userId],
    @"started" : [NSNumber numberWithBool: mazeUser.started],
    @"finished" : [NSNumber numberWithBool: mazeUser.finished],
    @"rating" : [NSNumber numberWithFloat: mazeUser.rating]};

    NSError *error = nil;
    
    NSData *requestBody = [RKMIMETypeSerialization dataFromObject: @{@"maze_user" : mazeUserDictionary}
                                                         MIMEType: RKMIMETypeJSON
                                                            error: &error];

    if (error != nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to serialize parameters. Error = %@", [error localizedDescription]];
    }


    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"/maze_users/%d.json", mazeUser.id]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];

    [request setHTTPMethod: @"PUT"];
    [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody: requestBody];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[]];
    
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsSaveMazeUserWithError: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to set mazeUser on server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsSaveMazeUserWithError: error];
     }];
        
    return objectRequestOperation;
}


- (RKObjectRequestOperation *)saveMazeRatingOperationWithDelegate: (id<MAServerOperationsSaveMazeRatingDelegate>)delegate rating: (Rating *)rating
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/setMazeRating/%d/%d/%f.json", rating.mazeId, rating.userId, rating.value]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[]];
    
    
    Class class = [self class];
    
    [objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate serverOperationsSaveRatingWithError: nil];
     }
                                                  failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to set rating on server. Error: %@", [error localizedDescription]];
         
         [delegate serverOperationsSaveRatingWithError: error];
     }];
    
    return objectRequestOperation;
}


- (RKObjectRequestOperation *)highestRatedOperationWithDelegate: (id<MAServerOperationsHighestRatedListDelegate>)delegate userId: (int)userId
{
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/highestRatedList/%d.json", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                                     responseDescriptors: @[self.mainListItemResponseDescriptor]];
    
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
                                                                                     responseDescriptors: @[self.mainListItemResponseDescriptor]];
    
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
                                                                                     responseDescriptors: @[self.mainListItemResponseDescriptor]];
    
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



























