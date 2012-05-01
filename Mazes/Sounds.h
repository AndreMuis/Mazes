//
//  Sounds.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sound.h"

@interface Sounds : NSObject 
{
	NSMutableDictionary *dictionary;
	
	int count;
}

@property (nonatomic) int count;

- (id)initWithXML: (xmlDocPtr)doc;

- (void)populateWithXML: (xmlDocPtr)doc;

- (NSArray *)getSounds;

- (NSArray *)getSoundsSorted;

- (Sound *)getSoundForId: (int)soundId;

- (void)writeToConsole;

@end
