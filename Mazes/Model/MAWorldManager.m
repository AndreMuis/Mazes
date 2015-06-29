//
//  MAWorldManager.m
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAWorldManager.h"

#import "MAWorld.h"

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
    }
    
    return self;
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
            
            NSArray *worlds = [NSArray arrayWithArray: mutableWorlds];
            
            completionHandler(worlds, error);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

- (void)saveWithWorld: (MAWorld *)world
    completionHandler: (MAWorldManagerSaveWorldCompletionHandler)completionHandler
{
    CKRecord *worldRecord = [world record];

    [[[CKContainer defaultContainer] publicCloudDatabase] saveRecord: worldRecord
                                                   completionHandler: ^(CKRecord *worldRecord, NSError *error)
    {
        if (error == nil)
        {
            MAWorld *world = [MAWorld worldWithRecord: worldRecord];
            
            completionHandler(world, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

@end





















