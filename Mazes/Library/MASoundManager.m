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

@property (strong, nonatomic, readonly) Reachability *reachability;
@property (strong, nonatomic, readonly) MAWebServices *webServices;

@property (strong, nonatomic, readonly) NSArray *sounds;

@property (assign, nonatomic, readwrite) NSUInteger count;

@property (strong, nonatomic, readonly) UIAlertView *downloadErrorAlertView;

@end

@implementation MASoundManager

+ (id)soundManagerWithReachability: (Reachability *)reachability
                       webServices: (MAWebServices *)webServices
{
    MASoundManager *soundManager = [[MASoundManager alloc] initWithReachability: reachability
                                                                    webServices: webServices];
    return soundManager;
}

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices
{
    self = [super init];
	
	if (self)
	{
        _reachability = reachability;
        _webServices = webServices;
        
        _sounds = [NSArray array];
        
        _count = 0;
        
        _downloadErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: MARequestErrorMessage
                                                            delegate: self
                                                   cancelButtonTitle: @"Cancel"
                                                   otherButtonTitles: @"Retry", nil];
	}
	
    return self;
}

- (void)downloadSounds
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
         }
         else if (self.reachability.isReachable == YES)
         {
             [self.downloadErrorAlertView show];
         }
     }];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView == self.downloadErrorAlertView && buttonIndex == 1)
    {
        [self downloadSounds];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: [NSString stringWithFormat: @"AlertView not handled. AlertView: %@", alertView]];
    }
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























