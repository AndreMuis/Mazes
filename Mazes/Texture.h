//
//  Texture.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Texture : NSObject 
{
	int textureId;
	NSString *name;
	int width;
	int height;
	int repeats;
	int type;
	int order;
	CGRect imageViewFrame;
}

@property (nonatomic) int textureId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int repeats;
@property (nonatomic) int type;
@property (nonatomic) int order;
@property (nonatomic) CGRect imageViewFrame;

@end
