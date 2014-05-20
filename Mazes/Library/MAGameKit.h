//
//  MAGameKit.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol MAGameKitDelegate;

@interface MAGameKit : NSObject

+ (MAGameKit *)gameKitWithDelegate: (id<MAGameKitDelegate>)delegate;

- (instancetype)initWithDelegate: (id<MAGameKitDelegate>)delegate;

- (void)setupAuthenticateHandler;

@end
