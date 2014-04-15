//
//  FFLocalStorage.h
//  FF-IOS-Framework
//
//  Copyright (c) 2013 FatFractal, Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FFQueuedOperation.h"

@class FatFractal;

@protocol FFLocalStorage <NSObject>

/**
 Load operations from the local database.
 @return Array of FFQueuedOperation objects read from the local database.
 */
- (NSMutableArray *)loadQueuedOperationsFromLocalStorage:(FatFractal *)ff error:(NSError **)outErr;

/**
 Store an operation to the local database.
 @param op  The operation to store.
 */
- (void)storeQueuedOperationToLocalStorage:(FatFractal *)ff op:(FFQueuedOperation *)op error:(NSError **)outErr;

/**
 Remove an operation from the local database.
 @param op  The operation to remove.
 */
- (void)removeQueuedOperationFromLocalStorage:(FatFractal *)ff op:(FFQueuedOperation *)op error:(NSError **)outErr;

- (NSData *) loadDataFromCacheUsingKey:(NSString *)cacheKey tag:(NSString *)tag userGuid:(NSString *)userGuid error:(NSError **)outErr;
- (void) storeDataToCache:(NSData *)data key:(NSString *)cacheKey tag:(NSString *)tag userGuid:(NSString *)userGuid error:(NSError **)outErr;
- (void) removeDataFromCacheUsingKey:(NSString *)cacheKey userGuid:(NSString *)userGuid error:(NSError **)outErr;

/**
 * Deletes all offline queued operations and all cached data for every FatFractal instance which uses this LocalStorage
 */
- (void) wipeAllData;

/**
 * Deletes all offline queued operations for every FatFractal instance which uses this LocalStorage
 */
- (NSError *) wipeQueuedOperations;

/**
 * Deletes all cached data for every FatFractal instance which uses this LocalStorage
 */
- (NSError *) wipeCache;

- (BOOL) debug;
- (void) setDebug:(BOOL)flag;

@end
