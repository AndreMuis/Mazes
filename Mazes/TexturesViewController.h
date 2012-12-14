//
//  TexturesViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Styles.h"

@interface TexturesViewController : UIViewController 
{
	id textureDelegate; 
	SEL textureSelector; 
	id exitDelegate;
	SEL exitSelector;
}

@property (nonatomic, retain) id textureDelegate;
@property (nonatomic) SEL textureSelector;
@property (nonatomic, retain) id exitDelegate;
@property (nonatomic) SEL exitSelector;

- (void)setupScrollView;

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer; 

@end
