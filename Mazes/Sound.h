//
//  Sound.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml2/libxml/tree.h>
#import <libxml2/libxml/xpath.h>
#import <libxml2/libxml/xpathInternals.h>

#import "XML.h"

@interface Sound : NSObject 
{
	int soundId;
	NSString *name;
	
	AVAudioPlayer *player;
}

@property (nonatomic) int soundId;
@property (nonatomic, retain) NSString *name;

- (id)initWithXMLDoc: (xmlDocPtr)doc XMLNode: (xmlNodePtr)node;

- (void)playWithNumberOfLoops: (int)numberOfLoops;
- (void)stop;

@end
