//
//  MAEvent.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAEvent : NSObject

@property (readonly, strong, nonatomic) id target;
@property (readonly, assign, nonatomic) SEL action;
@property (readonly, strong, nonatomic) id object;
@property (readonly, assign, nonatomic) float intervalSecs;
@property (readonly, assign, nonatomic) BOOL repeats;

@property (assign, nonatomic, assign) float elapsedSecs;

- (id)initWithTarget: (id)target action: (SEL)action intervalSecs: (int)intervalSecs repeats: (BOOL)repeats;

- (id)initWithTarget: (id)target action: (SEL)action object: (id)object intervalSecs: (int)intervalSecs repeats: (BOOL)repeats;

@end
