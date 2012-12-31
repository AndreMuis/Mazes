//
//  MAEvents.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAEvents.h"

#import "Constants.h"
#import "MAEvent.h"
#import "Utilities.h"

@implementation MAEvents

+ (MAEvents *)shared
{
	static MAEvents *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
            instance = [[MAEvents alloc] init];
		}
	}
	
	return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        self->timer = [NSTimer timerWithTimeInterval: [Constants shared].eventTimerIntervalSecs
                                              target: self
                                            selector: @selector(timerFired:)
                                            userInfo: nil
                                             repeats: YES];
   
        [[NSRunLoop currentRunLoop] addTimer: self->timer forMode: NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer: self->timer forMode: UITrackingRunLoopMode];
                
        self->events = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addEvent: (MAEvent *)event
{
    if ([self hasEvent: event] == NO)
    {
        [self->events addObject: event];
    }
    else
    {
        [Utilities logWithClass: [self class]
                         format: @"Event already exists with target: %@ and action: %@", event.target, NSStringFromSelector(event.action)];
    }
}

- (BOOL)hasEvent: (MAEvent *)anEvent
{
    BOOL exists = NO;
    
    for (MAEvent *event in self->events)
    {
        if (event.target == anEvent.target && event.action == anEvent.action)
        {
            exists = YES;
        }
    }

    return exists;
}

- (void)removeEvent: (MAEvent *)event
{
    if ([self->events indexOfObject: event] != NSNotFound)
    {    
        [self->events removeObject: event];
    }
    else
    {
        [Utilities logWithClass: [self class] format: @"Collection does not contain event: %@", event];
    }
}

- (void)removeEventsWithTarget: (id)target
{
    NSMutableArray *eventsWithTarget = [NSMutableArray array];
    
    for (MAEvent *event in self->events)
    {
        if (event.target == target)
        {
            [eventsWithTarget addObject: event];
        }
    }
    
    [self->events removeObjectsInArray: eventsWithTarget];
}

- (void)timerFired: (NSTimer *)timer
{
    for (MAEvent *event in [NSArray arrayWithArray: self->events])
    {
        if (event.elapsedSecs >= event.intervalSecs)
        {
            event.elapsedSecs = 0.0;
            
            if ([event.target respondsToSelector: event.action] == YES)
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [event.target performSelector: event.action];
                #pragma clang diagnostic pop
            }
            else
            {
                [Utilities logWithClass: [self class] format: @"Target: %@ does not respond to selector: %@", event.target, NSStringFromSelector(event.action)];
            }

            if (event.repeats == NO)
            {
                [self removeEvent: event];
            }
        }

        event.elapsedSecs = event.elapsedSecs + [Constants shared].eventTimerIntervalSecs;
    }
}

@end














