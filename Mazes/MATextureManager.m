//
//  MATextureManager.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATextureManager.h"

#import "MAConstants.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MAUtilities.h"
#import "MATexture.h"

@interface  MATextureManager ()

@property (strong, nonatomic, readonly) NSArray *list;

@property (strong, nonatomic, readonly) PFQuery *query;
@property (strong, nonatomic, readonly) MAEvent *downloadEvent;

@end

@implementation MATextureManager

+ (MATextureManager *)shared
{
	static MATextureManager *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[MATextureManager alloc] init];
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
        
        _query = [MATexture query];
        
        _downloadEvent = [[MAEvent alloc] initWithTarget: self
                                                  action: @selector(download)
                                            intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                 repeats: NO];
	}
	
    return self;
}

- (void)downloadWithCompletionHandler: (TexturesDownloadCompletionHandler)handler
{
    [self.query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             _list = objects;
             
             for (MATexture *texture in self.list)
             {
                 texture.glId = [self.list indexOfObject: texture];
             }
             
             handler();
         }
         else
         {
             [MAUtilities logWithClass: [self class] format: @"Unable to get textures from server. Error: %@", error];
             
             [[MAEvents shared] addEvent: self.downloadEvent];
         }
     }];
}

- (void)cancelDownload
{
    [self.query cancel];
    [[MAEvents shared] removeEventsWithTarget: self];
}

- (int)count
{
	return self.list.count;
}

- (int)maxGLId
{
    return self.list.count - 1;
}

- (NSArray *)all
{
	return self.list;
}

- (NSArray *)sortedByKindThenOrder
{
    NSSortDescriptor *kindSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"kind" ascending: YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];

    NSArray *sortedArray = [self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: kindSortDescriptor, orderSortDescriptor, nil]];

    return sortedArray;
}

- (MATexture *)textureWithObjectId: (NSString *)objectId
{
    MATexture *texture = nil;
    
    NSUInteger index = [self.list indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop)
                        {
                            return [((MATexture *)obj).objectId isEqualToString: objectId] == YES;
                        }];
    
    if (index != NSNotFound)
    {
        texture = [self.list objectAtIndex: index];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Unable to find texture with objectId: %@", objectId];
    }
    
    return texture;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self all]];
}

@end













