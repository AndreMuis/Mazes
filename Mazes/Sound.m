//
//  Sound.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "Sound.h"

#import "Utilities.h"

@implementation Sound

@dynamic id; 
@dynamic name;
@dynamic createdDate;
@dynamic updatedDate;

- (void)awakeFromInsert
{
    [self setup];
}

- (void)awakeFromFetch
{
    [self setup];
}

- (void)setup
{
    NSString *path = [[NSBundle mainBundle] pathForResource: self.name ofType: @"caf"];

    NSError *error = nil;
    self->audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: &error];

    if (error == nil)
    {
        self->audioPlayer.volume = 1.0;
    }
    else
    {
        [Utilities logWithClass: [self class] format: @"Unable to create audio player for sound: %@", self];
    }
}

- (void)playWithNumberOfLoops: (int)numberOfLoops
{
	self->audioPlayer.numberOfLoops = numberOfLoops;
		
	[self->audioPlayer play];
}

- (void)stop
{
	[self->audioPlayer stop];
	
	self->audioPlayer.currentTime = 0.0;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"id = %@", self.id];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    desc = [NSString stringWithFormat: @"%@, createdDate = %@", desc, self.createdDate];
    desc = [NSString stringWithFormat: @"%@, updatedDate = %@", desc, self.updatedDate];
    
    return desc;
}

@end





















