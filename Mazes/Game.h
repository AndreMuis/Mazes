//
//  Game.h
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

#import "ServerOperations.h"

@interface Game : NSObject <ADBannerViewDelegate, MAServerOperationsGetVersionDelegate>
{
    NSOperationQueue *operationQueue;
}

@property (strong, nonatomic) ADBannerView *bannerView;

+ (Game *)shared;

- (void)checkVersion;

@end
