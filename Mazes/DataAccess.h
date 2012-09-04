//
//  DataAccess.h
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <RestKit/RestKit.h>

#import "Utilities.h"
#import "Version.h"
#import "Sound.h"
#import "Texture.h"

@protocol LoadVersionDelegate <NSObject>
@required
- (void)loadVersionSucceededWithVersion: (Version *)version;
- (void)loadVersionFailed;
@end

@interface DataAccess : NSObject <RKObjectLoaderDelegate>
{
    id<LoadVersionDelegate> versionDelegate;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)getVersionWithDelegate: (id<LoadVersionDelegate>)delegate;
- (void)loadSounds;
- (void)loadTextures;

- (void)clearData;

- (NSURL *)applicationDocumentsDirectory;

@end
