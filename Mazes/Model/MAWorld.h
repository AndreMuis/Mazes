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
@class MAWorldRating;

@interface MAWorld : NSObject

@property (readonly, strong, nonatomic) NSString *userRecordName;
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, assign, nonatomic) NSUInteger rows;
@property (readonly, assign, nonatomic) NSUInteger columns;
@property (readonly, assign, nonatomic) BOOL isPublic;
@property (readonly, strong, nonatomic) NSDate *creationDate;

@property (readonly, strong, nonatomic) NSDate *modificationDate;
@property (readonly, strong, nonatomic) NSString *modificationDateAsString;

@property (readonly, assign, nonatomic) NSUInteger ratingCount;
@property (readonly, assign, nonatomic) float averageRating;

+ (instancetype)worldWithRecord: (CKRecord *)record;

+ (instancetype)worldWithUserRecordName: (NSString *)userId
                                   name: (NSString *)name
                                   rows: (NSUInteger)rows
                                columns: (NSUInteger)columns
                               isPublic: (NSUInteger)isPublic;

- (instancetype)initWithRecordName: (NSString *)recordName
                    userRecordName: (NSString *)userRecordName
                              name: (NSString *)name
                              rows: (NSUInteger)rows
                           columns: (NSUInteger)columns
                          isPublic: (NSUInteger)isPublic
                  locationDataList: (NSArray *)locationDataList
                      wallDataList: (NSArray *)wallDataList
                    ratingDataList: (NSArray *)ratingDataList
                      creationDate: (NSDate *)creationDate
                  modificationDate: (NSDate *)modificationDate;

- (CKRecordID *)recordId;

- (CKRecord *)record;

- (void)updateWithRecord: (CKRecord *)record;

- (void)updateRecord: (CKRecord *)record;

- (MALocation *)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column;

- (NSUInteger)wallsCount;

- (MAWall *)wallAtIndex: (NSUInteger)index;

- (MAWall *)wallWithRow: (NSUInteger)row
                 column: (NSUInteger)column
               position: (MAWallPositionType)position;

- (void)addWall: (MAWall *)wall;

- (void)removeWall: (MAWall *)wall;

- (BOOL)hasRatingWithUserRecordName: (NSString *)userRecordName;

- (float)ratingValueWithUserRecordName: (NSString *)userRecordName;

- (void)rateWithUserRecordName: (NSString *)userRecordName
                   ratingValue: (float)ratingValue;

@end















