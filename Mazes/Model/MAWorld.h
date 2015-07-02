//
//  MAWorld.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <Foundation/Foundation.h>

#import "MAConstants.h"

@class MALocation;
@class MAWall;

@interface MAWorld : NSObject

@property (readonly, strong, nonatomic) NSString *userId;
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, assign, nonatomic) NSUInteger rows;
@property (readonly, assign, nonatomic) NSUInteger columns;
@property (readonly, assign, nonatomic) BOOL isPublic;
@property (readonly, strong, nonatomic) NSDate *creationDate;
@property (readonly, strong, nonatomic) NSDate *modificationDate;

+ (instancetype)worldWithRecord: (CKRecord *)record;

+ (instancetype)worldWithUserId: (NSString *)userId
                           name: (NSString *)name
                           rows: (NSUInteger)rows
                        columns: (NSUInteger)columns
                       isPublic: (NSUInteger)isPublic;

- (instancetype)initWithRecordName: (NSString *)recordName
                            userId: (NSString *)userId
                              name: (NSString *)name
                              rows: (NSUInteger)rows
                           columns: (NSUInteger)columns
                          isPublic: (NSUInteger)isPublic
                  locationDataList: (NSArray *)locationDataList
                      wallDataList: (NSArray *)wallDataList
                      creationDate: (NSDate *)creationDate
                  modificationDate: (NSDate *)modificationDate;

- (MALocation *)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column;

- (CKRecordID *)recordId;

- (CKRecord *)record;

- (void)updateRecord: (CKRecord *)record;

- (void)addWall: (MAWall *)wall;

- (void)removeWall: (MAWall *)wall;

- (MAWall *)wallWithRow: (NSUInteger)row
                 column: (NSUInteger)column
               position: (MAWallPositionType)position;

@end















