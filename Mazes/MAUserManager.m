//
//  MAUserManager.m
//  Mazes
//
//  Created by Andre Muis on 7/29/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAUserManager.h"

#import "MACloud.h"
#import "MAConstants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MAUser.h"
#import "MAUtilities.h"

@interface  MAUserManager ()

@property (strong, nonatomic, readonly) GetCurrentUserCompletionHandler getCurrentUserCompletionHandler;

@property (strong, nonatomic, readonly) PFQuery *query;

@property (strong, nonatomic, readonly) MAEvent *createCurrentUserEvent;
@property (strong, nonatomic, readonly) MAEvent *downloadCurrentUserEvent;

@end

@implementation MAUserManager

+ (MAUserManager *)shared
{
	static MAUserManager *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MAUserManager alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _currentUser = nil;
        
        _query = [MAUser query];
        
        _createCurrentUserEvent = [[MAEvent alloc] initWithTarget: self
                                                           action: @selector(createCurrentUser)
                                                     intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                          repeats: NO];

        _downloadCurrentUserEvent = [[MAEvent alloc] initWithTarget: self
                                                             action: @selector(downloadCurrentUser)
                                                       intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                            repeats: NO];
	}
	
    return self;
}

- (void)getCurrentUserWithCompletionHandler: (GetCurrentUserCompletionHandler)handler
{
    _getCurrentUserCompletionHandler = handler;
    
    if ([MACloud shared].currentUserObjectId != nil)
    {
        [self downloadCurrentUser];
    }
    else
    {
        [self createCurrentUser];
    }
}

- (void)createCurrentUser
{
    MAUser *currentUser = [MAUser object];
    
    [currentUser saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error)
    {
        if (error == nil)
        {
            self.currentUser = currentUser;
            [MACloud shared].currentUserObjectId = self.currentUser.objectId;
            
            self.getCurrentUserCompletionHandler();
        }
        else
        {
            [MAUtilities logWithClass: [self class] format: @"Unable to create current user. Error: %@", error];
            
            [[MAEvents shared] addEvent: self.createCurrentUserEvent];
        }
    }];
}

- (void)downloadCurrentUser
{
    [self.query getObjectInBackgroundWithId: [MACloud shared].currentUserObjectId
                                      block: ^(PFObject *object, NSError *error)
    {
        if (error == nil)
        {
            self.currentUser = (MAUser *)object;
            
            self.getCurrentUserCompletionHandler();
        }
        else
        {
            [MAUtilities logWithClass: [self class] format: @"Unable to get current user from server. Error: %@", error];
             
            [[MAEvents shared] addEvent: self.downloadCurrentUserEvent];
        }
    }];
}

- (void)cancelGetCurrentUser
{
    [self.query cancel];
    [[MAEvents shared] removeEventsWithTarget: self];
}

- (void)deleteCurrentUser
{
    [MACloud shared].currentUserObjectId = nil;
}

@end










