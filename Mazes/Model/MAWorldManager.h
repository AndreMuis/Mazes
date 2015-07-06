//
//  MAWorldManager.h
//  Mazes
//
//  Created by Andre Muis on 8/7/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <Foundation/Foundation.h>

@class MAWorld;

typedef void (^MAWorldManagerGetWorldsCompletionHandler)(NSError *error);
typedef void (^MAWorldManagerSaveWorldCompletionHandler)(MAWorld *world, NSError *error);

@interface MAWorldManager : NSObject

@property (readonly, assign, nonatomic) NSUInteger worldsCount;

+ (MAWorldManager *)worldManager;

- (void)getWorldsWithCompletionHandler: (MAWorldManagerGetWorldsCompletionHandler)completionHandler;

- (MAWorld *)worldAtIndex: (NSUInteger)index;

- (void)saveWithWorld: (MAWorld *)world
    completionHandler: (MAWorldManagerSaveWorldCompletionHandler)completionHandler;

@end
















