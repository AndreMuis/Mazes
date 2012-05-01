//
//  Communication.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Utilities.h"
#import "XML.h"

@interface Communication : NSObject <UIAlertViewDelegate>
{
	id delegate;
	SEL selector;
    
	NSString *Action;
	NSString *waitMessage;
    
	xmlDocPtr requestDoc;
    
	NSMutableData *receivedData;
	NSString *response;
	xmlDocPtr responseDoc;
    
	BOOL errorOccurred;
}

- (id)initWithDelegate: (id)del Selector: (SEL)selector Action: (NSString *)action WaitMessage: (NSString *)message;

@property (nonatomic) xmlDocPtr requestDoc;
@property (nonatomic) xmlDocPtr responseDoc;
@property (nonatomic) BOOL errorOccurred;

- (void)post;

- (void)showCommErrorAlert;

@end

