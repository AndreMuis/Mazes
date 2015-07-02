//
//  MAWorld.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAWorld.h"

#import "MALocation.h"
#import "MAWall.h"

@interface MAWorld ()

@property (readonly, strong, nonatomic) NSString *recordName;

@property (readonly, strong, nonatomic) NSArray *locations;
@property (readonly, strong, nonatomic) NSArray *walls;

@end

@implementation MAWorld

+ (instancetype)worldWithRecord: (CKRecord *)record
{
    MAWorld *world = [[MAWorld alloc] initWithRecordName: record.recordID.recordName
                                                  userId: record[@"userId"]
                                                    name: record[@"name"]
                                                    rows: [record[@"rows"] unsignedIntegerValue]
                                                 columns: [record[@"columns"] unsignedIntegerValue]
                                                isPublic: [record[@"isPublic"] boolValue]
                                        locationDataList: record[@"locationDataList"]
                                            wallDataList: record[@"wallDataList"]
                                            creationDate: record.creationDate
                                        modificationDate: record.modificationDate];
    
    return world;
}

+ (instancetype)worldWithUserId: (NSString *)userId
                           name: (NSString *)name
                           rows: (NSUInteger)rows
                        columns: (NSUInteger)columns
                       isPublic: (NSUInteger)isPublic
{
    MAWorld *world = [[MAWorld alloc] initWithRecordName: nil
                                                  userId: userId
                                                    name: name
                                                    rows: rows
                                                 columns: columns
                                                isPublic: isPublic
                                        locationDataList: nil
                                            wallDataList: nil
                                            creationDate: nil
                                        modificationDate: nil];
    
    return world;
}

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
{
    self = [super init];
    
    if (self)
    {
        _recordName = recordName;
        
        _userId = userId;
        _name = name;
        _rows = rows;
        _columns = columns;
        _isPublic = isPublic;
        
        NSMutableArray *mutableLocations = [NSMutableArray array];
        
        for (NSData *locationData in locationDataList)
        {
            MALocation *location = [NSKeyedUnarchiver unarchiveObjectWithData: locationData];
            [mutableLocations addObject: location];
        }
        
        _locations = [NSArray arrayWithArray: mutableLocations];
        
        NSMutableArray *mutableWalls = [NSMutableArray array];
        
        for (NSData *wallData in wallDataList)
        {
            MAWall *wall = [NSKeyedUnarchiver unarchiveObjectWithData: wallData];
            [mutableWalls addObject: wall];
        }

        _walls = [NSArray arrayWithArray: mutableWalls];
        
        _creationDate = creationDate;
        _modificationDate = modificationDate;
    }
    
    return self;
}

- (CKRecordID *)recordId
{
    CKRecordID *recordId = nil;
    
    if (self.recordName != nil)
    {
        recordId = [[CKRecordID alloc] initWithRecordName: self.recordName];
    }
    
    return recordId;
}

- (CKRecord *)record
{
    CKRecord *record = [[CKRecord alloc] initWithRecordType: @"Worlds"];
    [self updateRecord: record];
    
    return record;
}

- (void)updateRecord: (CKRecord *)record
{
    record[@"userId"] = self.userId;
    record[@"name"] = self.name;
    record[@"rows"] = @(self.rows);
    record[@"columns"] = @(self.columns);
    record[@"isPublic"] = @(self.isPublic);

    NSMutableArray *mutableLocationDataList = [NSMutableArray array];
    
    for (MALocation *location in self.locations)
    {
        NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject: location];
        [mutableLocationDataList addObject: locationData];
    }

    record[@"locationDataList"] = [NSArray arrayWithArray: mutableLocationDataList];

    NSMutableArray *mutableWallDataList = [NSMutableArray array];
    
    for (MAWall *wall in self.walls)
    {
        NSData *wallData = [NSKeyedArchiver archivedDataWithRootObject: wall];
        [mutableWallDataList addObject: wallData];
    }
    
    record[@"wallDataList"] = [NSArray arrayWithArray: mutableWallDataList];
}

- (MALocation *)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column
{
    MALocation *location = nil;
    
    return location;
}

- (void)addWall: (MAWall *)wall
{
    if ([self.walls containsObject: wall] == NO)
    {
        NSMutableArray *mutableWalls = [NSMutableArray arrayWithArray: self.walls];
        [mutableWalls addObject: wall];
        _walls = [NSArray arrayWithArray: mutableWalls];
    }
    else
    {
        NSLog(@"Wall already exists in list. wall = %@", wall);
    }
}

- (void)removeWall: (MAWall *)wall
{
    if ([self.walls containsObject: wall] == YES)
    {
        NSMutableArray *mutableWalls = [NSMutableArray arrayWithArray: self.walls];
        [mutableWalls removeObject: wall];
        _walls = [NSArray arrayWithArray: mutableWalls];
    }
    else
    {
        NSLog(@"Wall does not exist in list. wall = %@", wall);
    }
}

- (MAWall *)wallWithRow: (NSUInteger)row
                 column: (NSUInteger)column
               position: (MAWallPositionType)position
{
    MAWall *wall = nil;
    
    NSUInteger index = [self.walls indexOfObjectPassingTest: ^BOOL(MAWall *someWall, NSUInteger idx, BOOL *stop)
    {
        if (someWall.row == row &&
            someWall.column == column &&
            someWall.position == position)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    if (index != NSNotFound)
    {
        wall = [self.walls objectAtIndex: index];
    }
    
    return wall;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"userId = %@; ", self.userId];
    desc = [desc stringByAppendingFormat: @"name = %@; ", self.name];
    desc = [desc stringByAppendingFormat: @"rows = %d; ", (int)self.rows];
    desc = [desc stringByAppendingFormat: @"columns = %d; ", (int)self.columns];
    desc = [desc stringByAppendingFormat: @"isPublic = %d; ", self.isPublic];
    desc = [desc stringByAppendingFormat: @"locations = %@; ", self.locations];
    desc = [desc stringByAppendingFormat: @"walls = %@; ", self.walls];
    desc = [desc stringByAppendingFormat: @"creationDate = %@; ", self.creationDate];
    desc = [desc stringByAppendingFormat: @"modificationDate = %@>", self.modificationDate];

    return desc;
}

@end




















