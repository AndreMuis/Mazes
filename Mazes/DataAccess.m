//
//  DataAccess.m
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

- (id)init
{
    self = [super init];
	
    if (self)
	{
        RKObjectManager *objectManagerShared = [RKObjectManager objectManagerWithBaseURL: [NSURL URLWithString: @"http://173.45.249.212:3000"]];
        objectManagerShared.serializationMIMEType = RKMIMETypeJSON;
	}
	
    return self;
}

- (void)getversion
{
    RKObjectMapping *postMapping = [RKObjectMapping mappingForClass: [Post class]];
    
    [postMapping mapKeyPath: @"name" toAttribute: @"name"];
    [postMapping mapKeyPath: @"title" toAttribute: @"title"];
    [postMapping mapKeyPath: @"content" toAttribute: @"content"];

    [[RKObjectManager sharedManager].mappingProvider setMapping: postMapping forKeyPath: @""];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath: @"/posts/2" delegate: self];    
}

- (void)objectLoader: (RKObjectLoader*)objectLoader didLoadObject: (id)object
{   
    Post *post = (Post *)object;
    
    NSLog(@"%@", post);
}

- (void)objectLoader: (RKObjectLoader *)objectLoader didFailWithError: (NSError *)error 
{
    NSLog(@"FAIL: %@", objectLoader.response.bodyAsString);
}

@end
