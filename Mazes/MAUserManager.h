//
//  MAUserManager.h
//  Mazes
//
//  Created by Andre Muis on 7/29/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAUser;

typedef void (^GetCurrentUserCompletionHandler)();

@interface MAUserManager : NSObject

@property (strong, nonatomic) MAUser *currentUser;

+ (MAUserManager *)shared;

- (void)getCurrentUserWithCompletionHandler: (GetCurrentUserCompletionHandler)handler;

- (void)cancelGetCurrentUser;

- (void)deleteCurrentUser;

@end


