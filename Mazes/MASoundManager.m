//
//  MASoundManager.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MASoundManager.h"

#import "GameViewController.h"
#import "MAConstants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MASound.h"
#import "MAUtilities.h"

@interface MASoundManager ()

@property (strong, nonatomic, readonly) NSArray *list;

@property (strong, nonatomic, readonly) PFQuery *query;
@property (strong, nonatomic, readonly) MAEvent *downloadEvent;

@end

@implementation MASoundManager

+ (MASoundManager *)shared
{
	static MASoundManager *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MASoundManager alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _list = [NSArray array];
        
        _query = [MASound query];
        
        _downloadEvent = [[MAEvent alloc] initWithTarget: self
                                                  action: @selector(download)
                                            intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                 repeats: NO];
	}
	
    return self;
}

- (int)count
{
    return self.list.count;
}

- (void)downloadWithCompletionHandler: (SoundsDownloadCompletionHandler)handler
{
    [self.query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error)
    {
        if (error == nil)
        {
            _list = objects;
            
            for (MASound *sound in self.list)
            {
                [sound setup];
            }
            
            handler();
        }
        else
        {
            [MAUtilities logWithClass: [self class] format: @"Unable to get sounds from server. Error: %@", error];
             
            [[MAEvents shared] addEvent: self.downloadEvent];
        }
    }];
}

- (void)cancelDownload
{
    [self.query cancel];
    [[MAEvents shared] removeEventsWithTarget: self];
}

- (NSArray *)sortedByName
{
    NSArray *sortedArray = [self.list sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2)
    {
        NSString *name1 = ((MASound *)obj1).name;
        NSString *name2 = ((MASound *)obj2).name;
        
        return [name1 compare: name2];
    }];
    
    return sortedArray;
}

- (MASound *)soundWithObjectId: (NSString *)objectId
{
    MASound *sound = nil;
    
    NSUInteger index = [self.list indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop)
    {
        return [((MASound *)obj).objectId isEqualToString: objectId] == YES;
    }];
    
    if (index != NSNotFound)
    {
        sound = [self.list objectAtIndex: index];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Unable to find sound with objectId: %@", objectId];
    }
    
    return sound;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self sortedByName]];
}

@end























