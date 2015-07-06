//
//  MAWorldManager.m
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAWorldManager.h"

#import "MAWorld.h"

@interface MAWorldManager ()

@property (readonly, strong, nonatomic) NSArray *worlds;

@end

@implementation MAWorldManager

+ (MAWorldManager *)worldManager
{
    MAWorldManager *worldManager = [[MAWorldManager alloc] init];
    
    return worldManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _worlds = nil;
    }
    
    return self;
}

- (NSUInteger)worldsCount
{
    return self.worlds.count;
}

- (void)getWorldsWithCompletionHandler: (MAWorldManagerGetWorldsCompletionHandler)completionHandler
{
    NSPredicate *predicate = [NSPredicate predicateWithValue: YES];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType: @"Worlds"
                                               predicate: predicate];
    
    [[[CKContainer defaultContainer] publicCloudDatabase] performQuery: query
                                                          inZoneWithID: nil
                                                     completionHandler: ^(NSArray *worldRecords, NSError *error)
    {
        if (error == nil)
        {
            NSMutableArray *mutableWorlds = [NSMutableArray array];

            for (CKRecord *worldRecord in worldRecords)
            {
                MAWorld *world = [MAWorld worldWithRecord: worldRecord];
                [mutableWorlds addObject: world];
            }
            
            _worlds = [NSArray arrayWithArray: mutableWorlds];
        }

        dispatch_async(dispatch_get_main_queue(), ^
        {
            completionHandler(error);
        });
    }];
}

- (MAWorld *)worldAtIndex: (NSUInteger)index
{
    MAWorld *world = nil;
    
    if (index < self.worlds.count)
    {
        world = [self.worlds objectAtIndex: index];
    }
    else
    {
        NSLog(@"No world exists at index. index = %d", (int)index);
    }
    
    return world;
}

- (void)saveWithWorld: (MAWorld *)world
    completionHandler: (MAWorldManagerSaveWorldCompletionHandler)completionHandler
{
    CKRecordID *recordId = [world recordId];
    
    if (recordId == nil)
    {
        CKRecord *worldRecord = [world record];
        
        [[[CKContainer defaultContainer] publicCloudDatabase] saveRecord: worldRecord
                                                       completionHandler: ^(CKRecord *worldRecord, NSError *error)
        {
            if (error == nil)
            {
                [world updateWithRecord: worldRecord];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                completionHandler(world, error);
            });
        }];
    }
    else
    {
        [[[CKContainer defaultContainer] publicCloudDatabase] fetchRecordWithID: recordId
                                                              completionHandler: ^(CKRecord *worldRecord, NSError *error)
        {
            [world updateRecord: worldRecord];

            if (error == nil)
            {
                [[[CKContainer defaultContainer] publicCloudDatabase] saveRecord: worldRecord
                                                               completionHandler: ^(CKRecord *worldRecord, NSError *error)
                {
                    if (error == nil)
                    {
                        [world updateWithRecord: worldRecord];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        completionHandler(world, error);
                    });
                }];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    completionHandler(nil, error);
                });
            }
        }];
    }
}

@end





















