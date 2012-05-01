//
//  Tester.m
//  iPad_Mazes
//
//  Created by Andre Muis on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tester.h"

@implementation Tester

- (void)XPath
{
	xmlDocPtr doc = [XML createDocXML: @"<?xml version=\"1.0\"?><Request><Locations><Location><MazeId>1</MazeId></Location><Location><MazeId>2</MazeId></Location></Locations></Request>"];  
	
	xmlNodePtr node = [XML getNodesFromDoc: doc XPath: "/Request/Locations/Location"];

	xmlNodePtr nodeCurr;
	for (nodeCurr = node; nodeCurr; nodeCurr = nodeCurr->next)
	{
		NSString *tmp =	[XML getNodeValueFromDoc: doc Node: nodeCurr XPath: "MazeId"];
		
		NSLog(@"%@", tmp);		
	}
	
	xmlFreeNodeList(node);
	xmlFreeDoc(doc);			
}

- (void)NSArray
{
	NSArray *startDirectionThetas = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 270], nil];
		
	int row;
	
	NSNumber *a = [NSNumber numberWithInt: 90];
	NSNumber *b = [NSNumber numberWithInt: 99];
	
	NSLog(@"%d", [a isEqual: b]);
	
	row = [startDirectionThetas indexOfObjectIdenticalTo: [NSNumber numberWithInt: 0]];
	NSLog(@"%d", row);

	row = [startDirectionThetas indexOfObjectIdenticalTo: [NSNumber numberWithInt: 9]];
	NSLog(@"%d", row);

	row = [startDirectionThetas indexOfObjectIdenticalTo: [NSNumber numberWithInt: 20]];
	NSLog(@"%d", row);

	row = [startDirectionThetas indexOfObjectIdenticalTo: [NSNumber numberWithInt: 270]];
	NSLog(@"%d", row);
}

- (void)FloatRounding
{
	float x = 0.0;
	float dx = 13.0 / 7.0;
	NSLog(@"%f", dx);
	
	for (int i = 1; i <= 7; i = i + 1)
	{
		x = x + dx;
		
		NSLog(@"%0.20f", x);
	}
	
	NSLog(@"%ld", lroundf(12.9));
	NSLog(@"%ld", lroundf(13.1));
}

@end














