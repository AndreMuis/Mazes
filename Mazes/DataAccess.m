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

- (void)getVersion
{
    RKObjectMapping *versionMapping = [RKObjectMapping mappingForClass: [Version class]];
    
    [versionMapping mapKeyPath: @"number" toAttribute: @"number"];

    [[RKObjectManager sharedManager].mappingProvider setMapping: versionMapping forKeyPath: @""];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath: @"/versions/1" delegate: self];    
}

- (void)objectLoader: (RKObjectLoader*)objectLoader didLoadObject: (id)object
{   
    Version *version = (Version *)object;
    
    NSLog(@"%@", version);
}

- (void)objectLoader: (RKObjectLoader *)objectLoader didFailWithError: (NSError *)error 
{
    NSLog(@"FAIL: %@", objectLoader.response.bodyAsString);
}

@end
