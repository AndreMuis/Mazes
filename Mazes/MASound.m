//
//  MASound.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "MASound.h"

#import "MAUtilities.h"

@interface MASound ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MASound

@dynamic name;

@synthesize audioPlayer;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

- (void)setup
{
    NSString *path = [[NSBundle mainBundle] pathForResource: self.name ofType: @"caf"];
    
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: &error];
    
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
    NSString *desc = [NSString stringWithFormat: @"objectId = %@", self.objectId];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    
    return desc;
}

@end





















