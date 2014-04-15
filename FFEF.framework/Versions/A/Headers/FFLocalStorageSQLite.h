//
//  FFLocalStorageSQLite.h
//  FF-IOS-Framework
//
//  Copyright (c) 2013 FatFractal, Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FFLocalStorage.h"

#define SQL_DB_FILENAME             @"FFLocalStorageSQLite"

#define SQL_QUEUE_TABLE             @"OPERATIONS"
#define SQL_CACHE_TABLE             @"CACHE"

#define SQL_APP_URI_FIELD           @"APPURI"
#define SQL_SESSIONID_FIELD         @"SESSIONID"
#define SQL_USERGUID_FIELD          @"USERGUID"
#define SQL_ROWID_FIELD             @"rowid"
#define SQL_TIMESTAMP_FIELD         @"TIMESTAMP"

#define SQL_QUEUE_METHOD_FIELD      @"METHOD"
#define SQL_QUEUE_URI_FIELD         @"URI"
#define SQL_QUEUE_OBJ_FIELD         @"OBJECT"
#define SQL_QUEUE_OBJBLOBS_FIELD    @"OBJBLOBS"
#define SQL_QUEUE_BLOB_SIZE_FIELD   @"BLOBSIZE"
#define SQL_QUEUE_BLOB_FIELD        @"BLOB"
#define SQL_QUEUE_MIME_FIELD        @"MIME"
#define SQL_QUEUE_MEMBERNAME_FIELD  @"MEMBERNAME"

#define SQL_CACHE_KEY_FIELD         @"QUERY_NAME"
#define SQL_CACHE_SIZE_FIELD        @"CACHED_SIZE"
#define SQL_CACHE_DATA_FIELD        @"CACHED_DATA"
#define SQL_CACHE_TAG_FIELD         @"CACHED_TAG"

@interface FFLocalStorageSQLite : NSObject <FFLocalStorage>

@property (readonly, strong, nonatomic) NSString *key;
@property (readonly)    NSString    *localQueueDBPath;

- (id)initWithDatabaseKey:(NSString *)key;

- (sqlite3 *)openDB;

- (BOOL)closeDB:(sqlite3 *)db;

- (NSURL *)urlForTmpDir;

@end
