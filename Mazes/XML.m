//
//  XML.m
//  iPad_Mazes
//
//  Created by Andre Muis on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XML.h"

@implementation XML

+ (xmlDocPtr)createDocXML: (NSString *)xml
{
	xmlDocPtr doc = xmlParseMemory([xml UTF8String], [xml lengthOfBytesUsingEncoding: NSUTF8StringEncoding]);
	
	return doc;
}

+ (xmlNodePtr)CreateNodeDoc: (xmlDocPtr)doc NodeName: (NSString *)nodeName
{
	xmlNodePtr node = xmlNewNode(nil, (const xmlChar *)[nodeName UTF8String]);
	node = xmlDocCopyNode(node, doc, 1);
	
	return node;
}

+ (xmlNodePtr)getRootNodeDoc: (xmlDocPtr) doc
{
	xmlNodePtr root = xmlDocGetRootElement(doc);
	
	return root;
}

+ (void)AddChildNode: (xmlNodePtr)child ToParent: (xmlNodePtr)parent 
{
	xmlAddChild(parent, child);
}

// add node to any node, doc is needed to create a new node
+ (xmlNodePtr)addNodeDoc: (xmlDocPtr)doc Parent: (xmlNodePtr)parent NodeName: (NSString *)nodeName NodeValue: (NSString *)nodeValue
{
	xmlNodePtr node = [self CreateNodeDoc: doc NodeName: nodeName];
	xmlAddChild(parent, node);

	xmlNodePtr textNode = xmlNewText((const xmlChar *)[nodeValue UTF8String]);
	xmlAddChild(node, textNode);
	
	return node;
}

+ (NSString *)convertDocToString: (xmlDocPtr)doc
{
	xmlChar *buffer = NULL;
	int bufferSize = 0;
	
	xmlDocDumpMemory(doc, &buffer, &bufferSize);
	
	NSString *strXML = [[NSString alloc] initWithFormat: @"%s", buffer];
	xmlFree(buffer); 
	
	return strXML;
}

+ (xmlNodePtr)getNodesFromDoc: (xmlDocPtr)doc XPath: (char *)xpath
{
	xmlXPathContextPtr context = xmlXPathNewContext(doc);
	
	xmlXPathObjectPtr result = xmlXPathEvalExpression((xmlChar *)xpath, context);

	xmlNodePtr node = xmlDocCopyNodeList(doc, result->nodesetval->nodeTab[0]);

	xmlXPathFreeContext(context);
	xmlXPathFreeObject (result);
	xmlCleanupParser();
	
	return node;
}

+ (NSString *)getNodeValueFromDoc: (xmlDocPtr)doc Node: (xmlNodePtr)node XPath: (char *)xpath
{
	xmlXPathContextPtr context = xmlXPathNewContext(doc);
	context->node = node;
	
	xmlXPathObjectPtr result = xmlXPathEvalExpression((xmlChar *)xpath, context);
	
	xmlXPathFreeContext(context);
	
	xmlNodeSetPtr nodeset = result->nodesetval;
	
	NSString *value;
	if (nodeset->nodeTab[0]->xmlChildrenNode != nil)
	{
		xmlChar *keyword = xmlNodeListGetString(doc, nodeset->nodeTab[0]->xmlChildrenNode, 1);
		value = [[NSString alloc] initWithFormat: @"%s", (char *)keyword];
		xmlFree(keyword);
	}
	else 
	{
		value = @"";
	}

	xmlXPathFreeObject (result);
	xmlCleanupParser();
	
	return value;
}

+ (BOOL)isDocEmpty: (xmlDocPtr)doc
{
	BOOL empty = YES;
	
	xmlNodePtr root = [self getRootNodeDoc: doc];
	
	if (root->children == nil)
		empty = YES;
	else 
		empty = NO;
	
	return empty;
}

@end
