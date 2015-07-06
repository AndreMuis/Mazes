//
//  MACurrentUser.h
//  Mazes
//
//  Created by Andre Muis on 7/3/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <Foundation/Foundation.h>

typedef void (^MACurrentUserFetchUserRecordIDCompletionHandler)(NSError *error);

@interface MACurrentUser : NSObject

@property (readonly, strong, nonatomic) NSString *recordname;

+ (instancetype)shared;

- (void)fetchUserRecordIDWithCompletionHandler: (MACurrentUserFetchUserRecordIDCompletionHandler)completionHandler;

@end
