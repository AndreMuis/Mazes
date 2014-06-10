//
//  MAEventManager.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAEventManager.h"

#import "MAConstants.h"
#import "MAEvent.h"
#import "MAUtilities.h"

@interface MAEventManager ()

@property (readonly, strong, nonatomic) NSTimer *timer;
@property (readonly, strong, nonatomic) NSMutableArray *events;

@end

@implementation MAEventManager

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        _timer = [NSTimer timerWithTimeInterval: MAEventTimerIntervalSecs
                                         target: self
                                       selector: @selector(timerFired:)
                                       userInfo: nil
                                        repeats: YES];
   
        [[NSRunLoop currentRunLoop] addTimer: self.timer forMode: NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer: self.timer forMode: UITrackingRunLoopMode];
                
        _events = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addEvent: (MAEvent *)event
{
    if ([self hasEvent: event] == NO)
    {
        [self.events addObject: event];
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"event already exists."
                       parameters: @{@"event.target" : [MAUtilities objectOrNull: event.target],
                                     @"event.action" : NSStringFromSelector(event.action)}];
    }
}

- (BOOL)hasEvent: (MAEvent *)anEvent
{
    BOOL exists = NO;
    
    for (MAEvent *event in self.events)
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
    if ([self.events indexOfObject: event] != NSNotFound)
    {    
        [self.events removeObject: event];
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"event not found."
                       parameters: @{@"event" : [MAUtilities objectOrNull: event]}];
    }
}

- (void)removeEventsWithTarget: (id)target
{
    NSMutableArray *eventsWithTarget = [NSMutableArray array];
    
    for (MAEvent *event in self.events)
    {
        if (event.target == target)
        {
            [eventsWithTarget addObject: event];
        }
    }
    
    [self.events removeObjectsInArray: eventsWithTarget];
}

- (void)timerFired: (NSTimer *)timer
{
    for (MAEvent *event in [NSArray arrayWithArray: self.events])
    {
        if (event.elapsedSecs >= event.intervalSecs)
        {
            event.elapsedSecs = 0.0;
            
            if ([event.target respondsToSelector: event.action] == YES)
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [event.target performSelector: event.action withObject: event.object];
                #pragma clang diagnostic pop
            }
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"target does not respond to selector."
                               parameters: @{@"event.target" : [MAUtilities objectOrNull: event.target],
                                             @"event.action" : NSStringFromSelector(event.action)}];
            }

            if (event.repeats == NO)
            {
                [self removeEvent: event];
            }
        }

        event.elapsedSecs = event.elapsedSecs + MAEventTimerIntervalSecs;
    }
}

@end














