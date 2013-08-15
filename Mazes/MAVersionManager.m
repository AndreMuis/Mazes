//
//  MAVersionManager.m
//  Mazes
//
//  Created by Andre Muis on 7/27/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAVersionManager.h"

#import "MAConstants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MAVersion.h"
#import "MAUtilities.h"

@interface  MAVersionManager ()

@property (strong, nonatomic, readonly) PFQuery *query;
@property (strong, nonatomic, readonly) MAEvent *downloadEvent;

@end

@implementation MAVersionManager

+ (MAVersionManager *)shared
{
	static MAVersionManager *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MAVersionManager alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _version = nil;
        
        _query = [MAVersion query];
        
        _downloadEvent = [[MAEvent alloc] initWithTarget: self
                                                  action: @selector(download)
                                            intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                 repeats: NO];
	}
	
    return self;
}

- (void)downloadWithCompletionHandler: (VersionDownloadCompletionHandler)handler
{
    [self.query getFirstObjectInBackgroundWithBlock: ^(PFObject *object, NSError *error)
    {
        if (error == nil)
        {
            self.version = (MAVersion *)object;
            
            handler(self.version);
        }
        else
        {
            [MAUtilities logWithClass: [self class] format: @"Unable to get version from server. Error: %@", error];
            
            [[MAEvents shared] addEvent: self.downloadEvent];
        }
    }];
}

- (void)cancelDownload
{
    [self.query cancel];
    [[MAEvents shared] removeEventsWithTarget: self];
}

@end













