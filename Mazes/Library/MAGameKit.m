//
//  MAGameKit.m
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAGameKit.h"

#import "MAGameKitDelegate.h"

@interface MAGameKit ()

@property (readonly, weak, nonatomic) id<MAGameKitDelegate> delegate;

@end

@implementation MAGameKit

+ (MAGameKit *)gameKitWithDelegate: (id<MAGameKitDelegate>)delegate
{
    MAGameKit *gameKit = [[MAGameKit alloc] init];
    
    return gameKit;
}

- (instancetype)initWithDelegate: (id<MAGameKitDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
    }
    
    return self;
}

- (void)setupAuthenticateHandler
{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (error == nil)
        {
            if (viewController != nil)
            {
                [self.delegate gameKit: self didReceiveAuthenticationViewController: viewController];
            }
            else
            {
                [self.delegate gameKitLocalPlayerAuthenticationComplete: self];
            }
        }
        else
        {
            [self.delegate gameKit: self didFailLocalPlayerAuthenticationWithError: error];
        }
    };
}

@end




















