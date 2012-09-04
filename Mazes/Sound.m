//
//  Sound.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"

@implementation Sound

@dynamic id; 
@dynamic name;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        DLog(@"%@ %@", self.id, self.name);
        
        /*
		self.id = [NSNumber numberWithInt: [[XML getNodeValueFromDoc: doc Node: node XPath: "SoundId"] intValue]];
		self.name = [XML getNodeValueFromDoc: doc Node: node XPath: "Name"];
		
		NSString *path = [[NSBundle mainBundle] pathForResource: self.name ofType: @"caf"];
        NSError *error;

		player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: &error];
		
		player.volume = 1.0;

		[player prepareToPlay];
         */
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
