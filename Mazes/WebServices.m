//
//  WebServices.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"

#import "Constants.h"
#import "Sound.h"
#import "Texture.h"
#import "Utilities.h"
#import "Version.h"

#import "Textures.h"
#import "Sounds.h"

@implementation WebServices

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self->objectManager = [[RKObjectManager alloc] initWithBaseURL: [NSURL URLWithString: [Constants shared].serverBaseURL]];
        self->objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename: @"Mazes.sqlite"];
        self->objectManager.serializationMIMEType = RKMIMETypeJSON;
	}
	
    return self;
}

- (void)getVersionWithDelegate: (id<GetVersionDelegate>)delegate
{
    RKObjectMapping *versionMapping = [RKObjectMapping mappingForClass: [Version class]];
    [versionMapping mapKeyPath: @"number" toAttribute: @"number"];

    [self->objectManager.mappingProvider setMapping: versionMapping forKeyPath: @""];
    
    [self->objectManager loadObjectsAtResourcePath: @"/versions/1" usingBlock: ^(RKObjectLoader* objectLoader)
    {
        objectLoader.onDidLoadObject = ^(id object)
        {
            Version *version = (Version *)object;
            [delegate getVersionSucceededWithVersion: version];
        };
        
        objectLoader.onDidFailWithError = ^(NSError *error)
        {
            DLog(@"Object loader failed with error: %@", error.localizedDescription);
            
            [delegate getVersionFailed];
        };
    }];
}

- (void)getSoundsWithDelegate: (id<GetSoundsDelegate>)delegate
{
    RKManagedObjectMapping *soundMapping = [RKManagedObjectMapping mappingForClass: [Sound class]
                                                              inManagedObjectStore: self->objectManager.objectStore];
    soundMapping.primaryKeyAttribute = @"id";
    [soundMapping mapKeyPath: @"id" toAttribute: @"id"];
    [soundMapping mapKeyPath: @"name" toAttribute: @"name"];

    [self->objectManager.mappingProvider setObjectMapping: soundMapping forResourcePathPattern: @"/sounds"];

    [self->objectManager loadObjectsAtResourcePath: @"/sounds" usingBlock: ^(RKObjectLoader* objectLoader)
     {
         objectLoader.onDidLoadObjects = ^(NSArray *array)
         {
             [delegate getSoundsSucceeded];
         };
         
         objectLoader.onDidFailWithError = ^(NSError *error)
         {
             DLog(@"Object loader failed with error: %@", error.localizedDescription);
             
             [delegate getSoundsFailed];
         };
     }];
}

- (void)getTexturesWithDelegate: (id<GetTexturesDelegate>)delegate
{
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
}

@end



























