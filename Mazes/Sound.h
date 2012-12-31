//
//  Sound.h
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSManagedObject
{
	AVAudioPlayer *audioPlayer;
}

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

- (void)setup;

- (void)playWithNumberOfLoops: (int)numberOfLoops;

- (void)stop;

@end
