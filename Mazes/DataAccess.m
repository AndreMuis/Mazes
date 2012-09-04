//
//  DataAccess.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        RKObjectManager *sharedObjectManager = [RKObjectManager objectManagerWithBaseURL: [NSURL URLWithString: @"http://173.45.249.212:3000"]];
        sharedObjectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename: @"Mazes.sqlite"];
        sharedObjectManager.serializationMIMEType = RKMIMETypeJSON;
	}
	
    return self;
}

- (void)getVersionWithDelegate: (id<LoadVersionDelegate>)delegate
{
    versionDelegate = delegate;
    
    RKObjectMapping *versionMapping = [RKObjectMapping mappingForClass: [Version class]];
    
    [versionMapping mapKeyPath: @"number" toAttribute: @"number"];

    [[RKObjectManager sharedManager].mappingProvider setMapping: versionMapping forKeyPath: @""];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath: @"/versions/1" delegate: self]; 
}

- (void)loadSounds
{
    RKManagedObjectMapping *soundMapping = [RKManagedObjectMapping mappingForClass: [Sound class] inManagedObjectStore: [RKObjectManager sharedManager].objectStore];
    soundMapping.primaryKeyAttribute = @"id";
    [soundMapping mapKeyPath: @"id" toAttribute: @"id"];
    [soundMapping mapKeyPath: @"name" toAttribute: @"name"];

    [[RKObjectManager sharedManager].mappingProvider setObjectMapping: soundMapping forResourcePathPattern: @"/sounds"];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath: @"/sounds" delegate: self];
}

- (void)loadTextures
{
    RKManagedObjectMapping *textureMapping = [RKManagedObjectMapping mappingForClass: [Texture class] inManagedObjectStore: [RKObjectManager sharedManager].objectStore];
    textureMapping.primaryKeyAttribute = @"id";
    [textureMapping mapKeyPath: @"id" toAttribute: @"id"];
    [textureMapping mapKeyPath: @"name" toAttribute: @"name"];
    [textureMapping mapKeyPath: @"width" toAttribute: @"width"];
    [textureMapping mapKeyPath: @"height" toAttribute: @"height"];
    [textureMapping mapKeyPath: @"repeats" toAttribute: @"repeats"];
    [textureMapping mapKeyPath: @"material" toAttribute: @"material"];
    [textureMapping mapKeyPath: @"order" toAttribute: @"order"];
    
    [[RKObjectManager sharedManager].mappingProvider setObjectMapping: textureMapping forResourcePathPattern: @"/textures"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath: @"/textures" delegate: self];
}

- (void)objectLoader: (RKObjectLoader*)objectLoader didLoadObject: (id)object
{   
    if ([object isKindOfClass: [Version class]] == YES)
    {
        Version *version = (Version *)object;
        
        [versionDelegate loadVersionSucceededWithVersion: version];
    }
    else 
    {
        DLog(@"Object not handled: %@", object);
    }
}

- (void)objectLoader: (RKObjectLoader *)objectLoader didLoadObjects: (NSArray *)objects   
{
}

- (void)objectLoader: (RKObjectLoader *)objectLoader didFailWithError: (NSError *)error 
{
    if ([objectLoader.resourcePath rangeOfString: @"versions"].location != NSNotFound)
    {
        [versionDelegate loadVersionFailed];
    }
}

- (void)clearData
{
    // sounds
    NSFetchRequest *soundsFetchRequest = [[NSFetchRequest alloc] init];
    [soundsFetchRequest setEntity: [NSEntityDescription entityForName: @"Sound" inManagedObjectContext: self.managedObjectContext]];
    [soundsFetchRequest setIncludesPropertyValues: NO]; //only fetch the managedObjD
    
    NSError *error = nil;
    NSArray *sounds = [self.managedObjectContext executeFetchRequest: soundsFetchRequest error: &error];
    
    if (error != nil)
    {
        DLog(@"%@", error);
    }
    
    for (NSManagedObject *sound in sounds) 
    {
        [self.managedObjectContext deleteObject: sound];
    }
    
    error = nil;
    [self.managedObjectContext save: &error];
    
    if (error != nil)
    {
        DLog(@"%@", error);
    }

    // textures
    NSFetchRequest *texturesFetchRequest = [[NSFetchRequest alloc] init];
    [texturesFetchRequest setEntity: [NSEntityDescription entityForName: @"Texture" inManagedObjectContext: self.managedObjectContext]];
    [texturesFetchRequest setIncludesPropertyValues: NO]; //only fetch the managedObjD
    
    error = nil;
    NSArray *textures = [self.managedObjectContext executeFetchRequest: texturesFetchRequest error: &error];
    
    if (error != nil)
    {
        DLog(@"%@", error);
    }
    
    for (NSManagedObject *texture in textures) 
    {
        [self.managedObjectContext deleteObject: texture];
    }
    
    error = nil;
    [self.managedObjectContext save: &error];
    
    if (error != nil)
    {
        DLog(@"%@", error);
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mazes" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mazes.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
    
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
    
@end
