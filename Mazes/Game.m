//
//  Game.m
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "Game.h"

#import "Constants.h"
#import "Flurry.h"
#import "Utilities.h"
#import "Version.h"

@implementation Game

+ (Game *)shared
{
	static Game *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Game alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        self->operationQueue = [[NSOperationQueue alloc] init];
        
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
	}
    
    return self;
}

- (void)bannerViewDidLoadAd: (ADBannerView *)banner
{
    [Flurry logEvent: @"bannerViewDidLoadAd:"
      withParameters: @{[[NSLocale currentLocale] localeIdentifier] : @"localeIdentifier"}];
}

- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *)error
{
    [Flurry logEvent: @"bannerView: didFailToReceiveAdWithError:"
      withParameters: @{[[NSLocale currentLocale] localeIdentifier] : @"localeIdentifier", [error localizedDescription] : @"error"}];
}

- (void)checkVersion
{
    [self->operationQueue addOperation: [[ServerOperations shared] getVersionOperationWithDelegate: self]];
}

- (void)serverOperationsGetVersion: (Version *)version error: (NSError *)error
{
    float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
    
    //NSLog(@"appVersion = %f, currentVersion = %f", appVersion, currentVersion);
    
    if (error == nil)
    {
        if (appVersion < version.number)
        {
            NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", appVersion, version.number];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                message: message
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
    }
    else
    {
        [self performSelector: @selector(checkVersion) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

@end




















