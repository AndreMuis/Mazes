//
//  MASound.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MASound.h"

#import "MAUtilities.h"

@interface MASound ()

@property (readonly, strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MASound

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _soundId = nil;
        _name = nil;
	}
	
    return self;
}

- (void)setup
{
    NSString *path = [[NSBundle mainBundle] pathForResource: self.name ofType: @"caf"];
    
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: &error];
    
    if (error == nil)
    {
        self.audioPlayer.volume = 1.0;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Unable to create audio player for sound: %@", self];
    }
}

- (void)playWithNumberOfLoops: (int)numberOfLoops
{
	self.audioPlayer.numberOfLoops = numberOfLoops;
		
	[self.audioPlayer play];
}

- (void)stop
{
	[self.audioPlayer stop];
	
	self.audioPlayer.currentTime = 0.0;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"soundId = %@; ", self.soundId];
    desc = [desc stringByAppendingFormat: @"name = %@>", self.name];
    
    return desc;
}

@end





















