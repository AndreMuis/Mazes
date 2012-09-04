//
//  Sounds.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sounds.h"

@implementation Sounds

@synthesize count;

- (int)count
{
    NSArray *sounds = [self getSoundsSorted]; 
    
	return sounds.count;
}

- (NSArray *)getSoundsSorted
{
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Sound" inManagedObjectContext: [Globals instance].dataAccess.managedObjectContext];   

    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity: entity];   

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];  
    NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    [request setSortDescriptors: sortDescriptors];  

    NSError *error = nil;  
    NSArray *sounds = [[Globals instance].dataAccess.managedObjectContext executeFetchRequest: request error: &error];   

    if (error != nil)
    {
        DLog(@"%@", error);
    }
	
	return sounds;
}

- (Sound *)getSoundForId: (int)soundId
{
    Sound *soundRet = nil;
    
    NSArray *sounds = [self getSoundsSorted]; 

    for (Sound *sound in sounds)
    {
        if ([sound.id intValue] == soundId)
        {
            soundRet = sound;
        }
    }
    
    if (soundRet == nil)
    {
        DLog(@"Could not find sound for Id = %d", soundId);
    }
    
	return soundRet;
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", [self getSoundsSorted]];
}

@end
