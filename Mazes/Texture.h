//
//  Texture.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Texture : NSManagedObject 
{
	int id;
	NSString *name;
	int width;
	int height;
	int repeats;
	int material;
	int order;
	CGRect imageViewFrame;
}

@property (nonatomic) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int repeats;
@property (nonatomic) int material;
@property (nonatomic) int order;
@property (nonatomic) CGRect imageViewFrame;

@end
