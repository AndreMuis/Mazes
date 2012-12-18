//
//  Sound.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"

#import "Utilities.h"

@implementation Sound

@dynamic id; 
@dynamic name;

- (id)initWithEntity: (NSEntityDescription *)entity insertIntoManagedObjectContext: (NSManagedObjectContext *)context
{
    self = [super initWithEntity: entity insertIntoManagedObjectContext: context];
	
    if (self)
    {
		NSString *path = [[NSBundle mainBundle] pathForResource: self.name ofType: @"caf"];
        
        NSError *error = nil;
		player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: &error];
		
        if (error == nil)
        {
            player.volume = 1.0;
        }
        else
        {
            [Utilities logWithClass: [self class] format: @"Unable to create audio player for sound: %@", self];
        }
	}
	
    return self;
}

- (void)playWithNumberOfLoops: (int)numberOfLoops
{
	player.numberOfLoops = numberOfLoops;
		
	[player play];
}

- (void)stop
{
	[player stop];
	
	player.currentTime = 0.0;
	
	[player prepareToPlay];
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"id = %@", self.id];
    desc = [NSString stringWithFormat: @"%@, name = %@", desc, self.name];
    
    return desc;
}

@end
