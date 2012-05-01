//
//  Communication.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Communication.h"

@implementation Communication
    
@synthesize requestDoc, responseDoc, errorOccurred;

- (id)initWithDelegate: (id)del Selector: (SEL)sel Action: (NSString *)action WaitMessage: (NSString *)message
{
    self = [super init];
    
    if (self)
	{
		delegate = del; 
		selector = sel;
		Action = action;
		waitMessage = message;
        
		requestDoc = [XML createDocXML: @"<?xml version=\"1.0\"?><Request></Request>"];  
		[XML addNodeDoc: requestDoc Parent: [XML getRootNodeDoc: requestDoc] NodeName: @"Action" NodeValue: action];
        
		receivedData = nil;
		response = @"";
		responseDoc = nil;
        
		errorOccurred = NO;
	}
    
    return self;
}

- (void)post
{
	[Utilities showActivityViewWithMessage: waitMessage];
    
	NSString *URL = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"Server URL"];
    
	NSString *keyEncoded = [Utilities URLEncode: @"Request"];
	NSString *valueEncoded = [Utilities URLEncode: [XML convertDocToString: requestDoc]];
    
	NSString *postBody = [NSString stringWithFormat: @"%@=%@", keyEncoded, valueEncoded];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
	[request setURL: [NSURL URLWithString: URL]];
	[request setHTTPMethod: @"POST"];
	[request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
	[request setHTTPBody: [postBody dataUsingEncoding: NSUTF8StringEncoding]];
    
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: request delegate: self];
    
	if (connection) 
	{
		receivedData = [NSMutableData data];
	} 
	else
	{
		[Utilities hideActivityView];
        
		errorOccurred = YES;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
		[delegate performSelector: selector];

        #pragma clang diagnostic pop
	}
}

- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)response
{
	[receivedData setLength: 0];
}

- (void)connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
	[receivedData appendData: data];
}

- (void)connection: (NSURLConnection *)connection didFailWithError: (NSError *)error
{
	[Utilities hideActivityView];
    
	errorOccurred = YES;

    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	[delegate performSelector: selector];

    #pragma clang diagnostic pop
}	 

- (void)connectionDidFinishLoading: (NSURLConnection *)connection
{	
	[Utilities hideActivityView];
    
	response = [[NSString alloc] initWithData: receivedData encoding: NSASCIIStringEncoding];
    
    responseDoc = [XML createDocXML: response];
    
	errorOccurred = NO;

    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	
    [delegate performSelector: selector];
    
    #pragma clang diagnostic pop
}

// used by the calling object to display a communication error alert if an error has occurred
- (void)showCommErrorAlert
{
	NSString *message = @"Unable to communicate with server.\n\nPlease make sure your iPad is connected to the internet\nor try again later.";
    
	[Utilities ShowAlertWithDelegate: self Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 0 Bounds: CGRectMake(0, 0, 600, 200)];
}

@end

