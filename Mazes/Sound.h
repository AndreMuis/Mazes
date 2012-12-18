//
//  Sound.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSManagedObject
{
	AVAudioPlayer *player;
}

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;

- (void)playWithNumberOfLoops: (int)numberOfLoops;
- (void)stop;

@end
