//
//  WebServices.h
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@class Version;

@protocol MAWebServicesGetVersionDelegate <NSObject>
@required
- (void)webServicesGetVersion: (Version *)version error: (NSError *)error;
@end

@protocol MAWebServicesGetSoundsDelegate <NSObject>
@required
- (void)webServicesGetSounds: (NSError *)error;
@end

@protocol MAWebServicesGetTexturesDelegate <NSObject>
@required
- (void)webServicesGetTextures: (NSError *)error;
@end

@protocol MAWebServicesGetHighestRatedDelegate <NSObject>
@required
- (void)webServicesGetHighestRated: (NSArray *)hightestRatedMainListItems error: (NSError *)error;
@end

@interface WebServices : NSObject
{
    RKObjectRequestOperation *objectRequestOperation;
    
    RKManagedObjectStore *managedObjectStore;
    RKManagedObjectRequestOperation *managedObjectRequestOperation;
}

- (void)getVersionWithDelegate: (id<MAWebServicesGetVersionDelegate>)delegate;

- (void)getSoundsWithDelegate: (id<MAWebServicesGetSoundsDelegate>)delegate;

- (void)getTexturesWithDelegate: (id<MAWebServicesGetTexturesDelegate>)delegate;

- (void)getHighestRatedWithDelegate: (id<MAWebServicesGetHighestRatedDelegate>)delegate userId: (int)userId;

@end
