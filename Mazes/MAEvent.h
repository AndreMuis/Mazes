//
//  MAEvent.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAEvent : NSObject

@property (strong, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic, assign) float intervalSecs;
@property (assign, nonatomic) BOOL repeats;

@property (assign, nonatomic, assign) float elapsedSecs;

- (id)initWithTarget: (id)aTarget action: (SEL)anAction intervalSecs: (int)anIntervalSecs repeats: (BOOL)aRepeats;

@end
