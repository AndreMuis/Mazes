//
//  MACurrentUser.m
//  Mazes
//
//  Created by Andre Muis on 7/3/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MACurrentUser.h"

@implementation MACurrentUser

+ (instancetype)shared
{
    static MACurrentUser *currentUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        currentUser = [[self alloc] init];
    });
    
    return currentUser;
}

- (void)fetchUserRecordIDWithCompletionHandler: (MACurrentUserFetchUserRecordIDCompletionHandler)completionHandler
{
    [[CKContainer defaultContainer] fetchUserRecordIDWithCompletionHandler: ^(CKRecordID *recordID, NSError *error)
    {
        if (error == nil)
        {
            _recordname = recordID.recordName;
        }
        else
        {
            if ([error.domain isEqualToString: @"CKErrorDomain"] == YES && error.code == CKErrorNotAuthenticated)
            {
                NSLog(@"User not authenticated.");
            }
            else
            {
                NSLog(@"%@", error);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            completionHandler(error);
        });
    }];
}

@end
















