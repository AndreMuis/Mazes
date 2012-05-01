//
//  MapSegment.h
//  iPad_Mazes
//
//  Created by Andre Muis on 8/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapSegment : NSObject 
{
	CGRect rect;
	UIColor *color;
}

@property (nonatomic) CGRect rect;
@property (nonatomic, retain) UIColor *color;

@end
