//
//  Game.m
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//
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
        _bannerView = nil;
	}
	
    return self;
}

- (ADBannerView *)bannerView
{
    if (_bannerView == nil)
    {
        _bannerView = [[ADBannerView alloc] initWithFrame: CGRectZero];
        //self.bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject: ADBAnner ADBannerContentSizeIdentifierPortrait];
        //self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        _bannerView.delegate = self;
    }
    
    return _bannerView;
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
    self->webServices = [[WebServices alloc] init];

    [self->webServices getVersionWithDelegate: self];
}

- (void)webServicesGetVersion: (Version *)currentVersion error: (NSError *)error
{
    float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
    
    //NSLog(@"appVersion = %f, currentVersion = %f", appVersion, currentVersion);
    
    if (error == nil)
    {
        if (appVersion < currentVersion.number)
        {
            NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", appVersion, currentVersion.number];
            
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




















