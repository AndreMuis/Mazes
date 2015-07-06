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
#import "MAWorldRating.h"

@interface MAWorld ()

@property (readonly, strong, nonatomic) NSString *recordName;

@property (readonly, strong, nonatomic) NSArray *locations;
@property (readonly, strong, nonatomic) NSArray *walls;
@property (readonly, strong, nonatomic) NSArray *ratings;

@end

@implementation MAWorld

+ (instancetype)worldWithRecord: (CKRecord *)record
{
    MAWorld *world = [[MAWorld alloc] initWithRecordName: record.recordID.recordName
                                          userRecordName: record[@"userRecordName"]
                                                    name: record[@"name"]
                                                    rows: [record[@"rows"] unsignedIntegerValue]
                                                 columns: [record[@"columns"] unsignedIntegerValue]
                                                isPublic: [record[@"isPublic"] boolValue]
                                        locationDataList: record[@"locationDataList"]
                                            wallDataList: record[@"wallDataList"]
                                          ratingDataList: record[@"ratingDataList"]
                                            creationDate: record.creationDate
                                        modificationDate: record.modificationDate];
    
    return world;
}

+ (instancetype)worldWithUserRecordName: (NSString *)userRecordName
                                   name: (NSString *)name
                                   rows: (NSUInteger)rows
                                columns: (NSUInteger)columns
                               isPublic: (NSUInteger)isPublic
{
    MAWorld *world = [[MAWorld alloc] initWithRecordName: nil
                                          userRecordName: userRecordName
                                                    name: name
                                                    rows: rows
                                                 columns: columns
                                                isPublic: isPublic
                                        locationDataList: nil
                                            wallDataList: nil
                                          ratingDataList: nil
                                            creationDate: nil
                                        modificationDate: nil];
    
    return world;
}

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
                  modificationDate: (NSDate *)modificationDate
{
    self = [super init];
    
    if (self)
    {
        [self updateWithRecordName: recordName
                    userRecordName: userRecordName
                              name: name
                              rows: rows
                           columns: columns
                          isPublic: isPublic
                  locationDataList: locationDataList
                      wallDataList: wallDataList
                    ratingDataList: ratingDataList
                      creationDate: creationDate
                  modificationDate: modificationDate];
    }
    
    return self;
}

- (NSString *)modificationDateAsString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle: NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.modificationDate];
}

- (NSUInteger)ratingCount
{
    return self.ratings.count;
}

- (float)averageRating
{
    float sum = 0.0;
    
    for (MAWorldRating *rating in self.ratings)
    {
        sum = sum + rating.value;
    }
    
    float average = sum / self.ratings.count;
    
    return average;
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

- (void)updateWithRecord: (CKRecord *)record
{
    [self updateWithRecordName: record.recordID.recordName
                userRecordName: record[@"userRecordName"]
                          name: record[@"name"]
                          rows: [record[@"rows"] unsignedIntegerValue]
                       columns: [record[@"columns"] unsignedIntegerValue]
                      isPublic: [record[@"isPublic"] boolValue]
              locationDataList: record[@"locationDataList"]
                  wallDataList: record[@"wallDataList"]
                ratingDataList: record[@"ratingDataList"]
                  creationDate: record.creationDate
              modificationDate: record.modificationDate];
}

- (void)updateWithRecordName: (NSString *)recordName
              userRecordName: (NSString *)userRecordName
                        name: (NSString *)name
                        rows: (NSUInteger)rows
                     columns: (NSUInteger)columns
                    isPublic: (NSUInteger)isPublic
            locationDataList: (NSArray *)locationDataList
                wallDataList: (NSArray *)wallDataList
              ratingDataList: (NSArray *)ratingDataList
                creationDate: (NSDate *)creationDate
            modificationDate: (NSDate *)modificationDate
{
    _recordName = recordName;
    
    _userRecordName = userRecordName;
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
    
    NSMutableArray *mutableRatings = [NSMutableArray array];
    
    for (NSData *ratingData in ratingDataList)
    {
        MAWorldRating *rating = [NSKeyedUnarchiver unarchiveObjectWithData: ratingData];
        [mutableRatings addObject: rating];
    }
    
    _ratings = [NSArray arrayWithArray: mutableRatings];
    
    _creationDate = creationDate;
    _modificationDate = modificationDate;
}

- (void)updateRecord: (CKRecord *)record
{
    record[@"userRecordName"] = self.userRecordName;
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

    NSMutableArray *mutableRatingDataList = [NSMutableArray array];
    
    for (MAWorldRating *rating in self.ratings)
    {
        NSLog(@"%@", rating);
        
        NSData *ratingData = [NSKeyedArchiver archivedDataWithRootObject: rating];
        [mutableRatingDataList addObject: ratingData];
    }
    
    record[@"ratingDataList"] = [NSArray arrayWithArray: mutableRatingDataList];
}

- (MALocation *)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column
{
    MALocation *location = nil;
    
    return location;
}

- (NSUInteger)wallsCount
{
    return self.walls.count;
}

- (MAWall *)wallAtIndex: (NSUInteger)index
{
    MAWall *wall = nil;

    if (index < self.walls.count)
    {
        wall = [self.walls objectAtIndex: index];
    }
    else
    {
        NSLog(@"No wall exists at index %d", (int)index);
    }
    
    return wall;
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

- (BOOL)hasRatingWithUserRecordName: (NSString *)userRecordName
{
    BOOL hasRating = NO;
   
    MAWorldRating *rating = [self ratingWithUserRecordName: userRecordName];
    
    if (rating == nil)
    {
        hasRating = NO;
    }
    else
    {
        hasRating = YES;
    }
    
    return hasRating;
}

- (float)ratingValueWithUserRecordName: (NSString *)userRecordName
{
    float ratingValue = 0.0;
    
    MAWorldRating *rating = [self ratingWithUserRecordName: userRecordName];

    if (rating != nil)
    {
        ratingValue = rating.value;
    }
    
    return ratingValue;
}

- (void)rateWithUserRecordName: (NSString *)userRecordName
                   ratingValue: (float)ratingValue
{
    MAWorldRating *rating = [self ratingWithUserRecordName: userRecordName];

    if (rating == nil)
    {
        MAWorldRating *newRating = [MAWorldRating worldRatingWithUserRecodName: userRecordName
                                                                         value: ratingValue];
        
        NSMutableArray *mutableRatings = [NSMutableArray arrayWithArray: self.ratings];
        [mutableRatings addObject: newRating];
        _ratings = [NSArray arrayWithArray: mutableRatings];
    }
    else
    {
        [rating updateWithValue: ratingValue];
    }
}

- (MAWorldRating *)ratingWithUserRecordName: (NSString *)userRecordName
{
    MAWorldRating *rating = nil;
    
    NSUInteger index = [self.ratings indexOfObjectPassingTest: ^BOOL(MAWorldRating *someRating, NSUInteger idx, BOOL *stop)
    {
        if ([someRating.userRecordName isEqualToString: userRecordName] == YES)
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
        rating = [self.ratings objectAtIndex: index];
    }
    
    return rating;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"userRecordName = %@; ", self.userRecordName];
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




















