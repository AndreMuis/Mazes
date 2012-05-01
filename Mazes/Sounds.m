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

- (id)initWithXML: (xmlDocPtr)doc
{
    self = [super init];
	
    if (self)
	{
		dictionary = [[NSMutableDictionary alloc] init];
		
		[self populateWithXML: doc];
	}
	
    return self;
}

- (void)populateWithXML: (xmlDocPtr)doc
{
	xmlNodePtr node = [XML getNodesFromDoc: doc XPath: "/Response/Sounds/Sound"];
	
	xmlNodePtr nodeCurr;
	for (nodeCurr = node; nodeCurr; nodeCurr = nodeCurr->next)
	{
		Sound *sound = [[Sound alloc] initWithXMLDoc: doc XMLNode: nodeCurr];
		
		[dictionary setObject: sound forKey: [NSNumber numberWithInt: sound.soundId]];
	}
	
	xmlFreeNodeList(node);
}

- (int)count
{
	return dictionary.count;
}

- (NSArray *)getSounds
{
	NSArray *sounds = [dictionary allValues];
	
	return sounds;
}

- (NSArray *)getSoundsSorted
{
	NSArray *sounds = [dictionary allValues];
	
	NSArray *soundsSorted = [sounds sortedArrayUsingComparator: (NSComparator)^(Sound *sound1, Sound *sound2)
							   {
								   int comparisonResult = [sound1.name compare: sound2.name];
								   
								   return comparisonResult; 
							   }];
	
	return soundsSorted;
}

- (Sound *)getSoundForId: (int)soundId
{
	return [dictionary objectForKey: [NSNumber numberWithInt: soundId]];
}

- (void)writeToConsole
{
	NSArray	*sounds = [self getSoundsSorted];
	
	NSLog(@"soundId name");  
	for(Sound *sound in sounds)
	{
		NSLog(@"%d %@", sound.soundId, sound.name);
	}
}

- (NSString *)description 
{
    return [NSString stringWithFormat: @"%@", dictionary];
}

@end
