//
//  MASoundManager.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MASoundManager.h"

#import "MAConstants.h"
#import "MAGameViewController.h"
#import "MASound.h"
#import "MAUtilities.h"
#import "MAWebServices.h"

@interface MASoundManager ()

@property (strong, nonatomic, readonly) MAWebServices *webServices;

@property (strong, nonatomic, readonly) NSArray *sounds;

@property (assign, nonatomic, readwrite) NSUInteger count;

@end

@implementation MASoundManager

+ (id)soundManagerWithWebServices: (MAWebServices *)webServices
{
    MASoundManager *soundManager = [[MASoundManager alloc] initWithWebServices: webServices];
    return soundManager;
}

- (id)initWithWebServices: (MAWebServices *)webServices
{
    self = [super init];
	
	if (self)
	{
        _webServices = webServices;
        
        _sounds = [NSArray array];
        
        _count = 0;
	}
	
    return self;
}

- (void)downloadSoundsWithCompletionHandler: (DownloadSoundsCompletionHandler)handler
{
    [self.webServices getSoundsWithCompletionHandler: ^(NSArray *sounds, NSError *error)
    {
        if (error == nil)
        {
            _sounds = sounds;
         
            for (MASound *sound in self.sounds)
            {
                [sound setup];
            }
         
            self.count = self.sounds.count;
         
            handler(nil);
        }
        else
        {
            handler(error);
        }
    }];
}

- (NSArray *)sortedByName
{
    NSArray *sortedArray = [self.sounds sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2)
    {
        NSString *name1 = ((MASound *)obj1).name;
        NSString *name2 = ((MASound *)obj2).name;
        
        return [name1 compare: name2];
    }];
    
    return sortedArray;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"sounds = %@>", self.sounds];

    return desc;
}

@end























