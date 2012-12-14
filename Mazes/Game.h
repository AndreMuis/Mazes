//
//  Game.h
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

#import "WebServices.h"

@interface Game : NSObject <GetVersionDelegate>
{
    WebServices *webServices;
}

@property (strong, nonatomic) ADBannerView *bannerView;

+ (Game *)shared;

- (void)checkVersion;

@end
