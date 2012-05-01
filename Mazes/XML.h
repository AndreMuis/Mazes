//
//  XML.h
//  iPad_Mazes
//
//  Created by Andre Muis on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml/tree.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

@interface XML : NSObject

+ (xmlDocPtr)createDocXML: (NSString *)xml;

+ (xmlNodePtr)CreateNodeDoc: (xmlDocPtr)doc NodeName: (NSString *)nodeName;

+ (xmlNodePtr)getRootNodeDoc: (xmlDocPtr) doc;

+ (void)AddChildNode: (xmlNodePtr)child ToParent: (xmlNodePtr)parent;

+ (xmlNodePtr)addNodeDoc: (xmlDocPtr)doc Parent: (xmlNodePtr)parent NodeName: (NSString *)nodeName NodeValue: (NSString *)nodeValue;

+ (NSString *)convertDocToString: (xmlDocPtr)doc;

+ (xmlNodePtr)getNodesFromDoc: (xmlDocPtr)doc XPath: (char *)xpath;
+ (NSString *)getNodeValueFromDoc: (xmlDocPtr)doc Node: (xmlNodePtr)node XPath: (char *)xpath;

+ (BOOL)isDocEmpty: (xmlDocPtr)doc;

@end
