//
//  MAEvent.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAEvent.h"

#import "Constants.h"
#import "Utilities.h"

@implementation MAEvent

- (id)initWithTarget: (id)aTarget action: (SEL)anAction intervalSecs: (int)anIntervalSecs repeats: (BOOL)aRepeats
{
    self = [super init];
    
    if (self) 
    {
        _target = aTarget;
        _action = anAction;
        _intervalSecs = anIntervalSecs;
        _repeats = aRepeats;
        
        _elapsedSecs = 0.0;
    }
    
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"target = %@\n", self.target];
    desc = [NSString stringWithFormat: @"%@action = %@\n", desc, NSStringFromSelector(self.action)];
    desc = [NSString stringWithFormat: @"%@intervalSecs = %f\n", desc, self.intervalSecs];
    desc = [NSString stringWithFormat: @"%@repeats = %d\n", desc, self.repeats];
    
    desc = [NSString stringWithFormat: @"%@elapsedSecs = %f\n", desc, self.elapsedSecs];
    
    return desc;
}

@end
