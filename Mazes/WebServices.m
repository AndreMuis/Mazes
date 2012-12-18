//
//  WebServices.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"

#import "Constants.h"
#import "MainListItem.h"
#import "Sound.h"
#import "Texture.h"
#import "Utilities.h"
#import "Version.h"

@implementation WebServices

- (id)init
{
    self = [super init];
	
    if (self)
	{
	}
	
    return self;
}

- (void)getVersionWithDelegate: (id<MAWebServicesGetVersionDelegate>)delegate
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
    
    self->objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                 responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [self->objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
    {
        Version *version = [result firstObject];
        
        [delegate webServicesGetVersion: version error: nil];
    }
                                                        failure: ^(RKObjectRequestOperation *operation, NSError *error)
    {
        [Utilities logWithClass: class format: @"Unable to get version from server. Error: %@", [error localizedDescription]];

        [delegate webServicesGetVersion: nil error: error];
    }];
    
    [self->objectRequestOperation start];
}

- (void)getSoundsWithDelegate: (id<MAWebServicesGetSoundsDelegate>)delegate
{
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles: nil];
 
    self->managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel: managedObjectModel];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent: @"Mazes.sqlite"];
    
    NSError *error = nil;
    
    [self->managedObjectStore addSQLitePersistentStoreAtPath: storePath fromSeedDatabaseAtPath: nil withConfiguration: nil options: nil error: &error];
    
    if (error != nil)
    {
        [Utilities logWithClass: [self class] format: @"Unable to add SQLite to persistent store. Error: %@", [error localizedDescription]];
    }
    
    [self->managedObjectStore createManagedObjectContexts];
    self->managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext: self->managedObjectStore.persistentStoreManagedObjectContext];
    
    RKEntityMapping *soundMapping = [RKEntityMapping mappingForEntityForName: @"Sound" inManagedObjectStore: self->managedObjectStore];
    
    [soundMapping addAttributeMappingsFromDictionary: @{@"id": @"id", @"name": @"name"}];
    soundMapping.identificationAttributes = @[@"id"];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: soundMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *soundsURL = [Constants shared].serverBaseURL;
    soundsURL = [soundsURL URLByAppendingPathComponent: @"sounds"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: soundsURL];
    
    [request addValue: @"application/json" forHTTPHeaderField: @"Accept"];

    self->managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest: request responseDescriptors: @[responseDescriptor]];
    
    self->managedObjectRequestOperation.managedObjectContext = self->managedObjectStore.mainQueueManagedObjectContext;
    
    self->managedObjectRequestOperation.managedObjectCache = self->managedObjectStore.managedObjectCache;
    
    [self->managedObjectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
    {
        Sound *sound = [result firstObject];
        NSLog(@"%@", sound);
    }
                                     failure: ^(RKObjectRequestOperation *operation, NSError *error)
    {
        NSLog(@"Unable to download sounds. Error: %@", [error localizedDescription]);
    }];
    
    [self->managedObjectRequestOperation start];
}

- (void)getTexturesWithDelegate: (id<MAWebServicesGetTexturesDelegate>)delegate
{
    /*
    RKManagedObjectMapping *textureMapping = [RKManagedObjectMapping mappingForClass: [Texture class]
                                                                inManagedObjectStore: self->objectManager.objectStore];
    textureMapping.primaryKeyAttribute = @"id";
    [textureMapping mapKeyPath: @"id" toAttribute: @"id"];
    [textureMapping mapKeyPath: @"name" toAttribute: @"name"];
    [textureMapping mapKeyPath: @"width" toAttribute: @"width"];
    [textureMapping mapKeyPath: @"height" toAttribute: @"height"];
    [textureMapping mapKeyPath: @"repeats" toAttribute: @"repeats"];
    [textureMapping mapKeyPath: @"kind" toAttribute: @"kind"];
    [textureMapping mapKeyPath: @"order" toAttribute: @"order"];
    
    [self->objectManager.mappingProvider setObjectMapping: textureMapping forResourcePathPattern: @"/textures"];
    
    [self->objectManager loadObjectsAtResourcePath: @"/textures" usingBlock: ^(RKObjectLoader* objectLoader)
     {
         objectLoader.onDidLoadObjects = ^(NSArray *array)
         {
             [delegate getTexturesSucceeded];
         };
        
         objectLoader.onDidFailWithError = ^(NSError *error)
         {
             DLog(@"Object loader failed with error: %@", error.localizedDescription);
             
             [delegate getTexturesFailed];
         };
     }];
     */
}

- (void)getHighestRatedWithDelegate: (id<MAWebServicesGetHighestRatedDelegate>)delegate userId: (int)userId
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass: [MainListItem class]];
    
    [objectMapping addAttributeMappingsFromDictionary:
     @{@"mazeId" : @"mazeId",
     @"mazeName" : @"mazeName",
     @"averageRating" : @"averageRating",
     @"ratingsCount" : @"ratingsCount",
     @"userStarted" : @"userStarted",
     @"userRating" : @"userRating",
     @"lastModified" : @"lastModified"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: objectMapping
                                                                                       pathPattern: nil
                                                                                           keyPath: nil
                                                                                       statusCodes: statusCodes];
    
    NSURL *url = [Constants shared].serverBaseURL;
    url = [url URLByAppendingPathComponent: [NSString stringWithFormat: @"main/highestRatedMazes/%d.json", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    [request addValue: @"application/json" forHTTPHeaderField: @"Accept"];
    
    self->objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest: request
                                                                 responseDescriptors: @[responseDescriptor]];
    
    Class class = [self class];
    
    [self->objectRequestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         [delegate webServicesGetHighestRated: [result array] error: nil];
     }
                                                        failure: ^(RKObjectRequestOperation *operation, NSError *error)
     {
         [Utilities logWithClass: class format: @"Unable to get main list items from server. Error: %@", [error localizedDescription]];
         
         [delegate webServicesGetHighestRated: nil error: error];
     }];
    
    [self->objectRequestOperation start];
}

@end



























