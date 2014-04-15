//
//  MASoundManager.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Reachability/Reachability.h>

@class MAWebServices;
@class Reachability;

@interface MASoundManager : NSObject <UIAlertViewDelegate>

@property (assign, nonatomic, readonly) NSUInteger count;

+ (id)soundManagerWithReachability: (Reachability *)reachability
                       webServices: (MAWebServices *)webServices;

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices;

- (void)downloadSounds;

- (NSArray *)sortedByName;

@end
