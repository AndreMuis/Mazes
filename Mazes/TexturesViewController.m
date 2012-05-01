    //
//  TexturesViewController.m
//  iPad_Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TexturesViewController.h"

@implementation TexturesViewController

@synthesize textureDelegate, textureSelector, exitDelegate, exitSelector;

- (void)loadView
{
	self.view = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0, 0.0, [Styles instance].editView.popoverTexturesWidth, [Styles instance].editView.popoverTexturesHeight)];
}

- (void)viewDidLoad
{
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
	tapRecognizer.numberOfTapsRequired = 1;
	tapRecognizer.numberOfTouchesRequired = 1;   
	
	[self.view addGestureRecognizer: tapRecognizer];

	[self setupScrollView];
}
	
- (void)setupScrollView
{
	self.view.backgroundColor = [Styles instance].editView.viewTexturesBackgroundColor;
	
	NSArray *textures = [[Globals instance].textures getTexturesSorted];
	
	float padding = ([Styles instance].editView.popoverTexturesWidth - [Styles instance].editView.texturesPerRow * [Styles instance].editView.textureImageLength) / ([Styles instance].editView.texturesPerRow + 1);
	
	int row = 1, column = 1;
	float x = 0.0, y = 0.0;
	for (Texture *texture in textures)
	{
		if (column > [Styles instance].editView.texturesPerRow)
		{
			column = 1;
			row = row + 1;
		}
		
		x = padding + (column - 1) * ([Styles instance].editView.textureImageLength + padding);
		y = padding + (row - 1) * ([Styles instance].editView.textureImageLength + padding);
		
		UIImage *image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
		
		CGRect imageViewFrame = CGRectMake(x, y, [Styles instance].editView.textureImageLength, [Styles instance].editView.textureImageLength);
		
		texture.imageViewFrame = imageViewFrame;
		
		imageView.frame = imageViewFrame;
		
		[self.view addSubview: imageView];
		
		column = column + 1;
	}
	
	UIScrollView *texturesView = (UIScrollView *)self.view;
	texturesView.contentSize = CGSizeMake([Styles instance].editView.popoverTexturesWidth, padding + row * ([Styles instance].editView.textureImageLength + padding));	
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint touchPoint = [recognizer locationInView: self.view];

	NSArray *textures = [[Globals instance].textures getTexturesSorted];

	for (Texture *texture in textures)
	{
		if (CGRectContainsPoint(texture.imageViewFrame, touchPoint) == YES)
		{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
			[textureDelegate performSelector: textureSelector withObject: [NSNumber numberWithInt: texture.textureId]];
			
			[exitDelegate performSelector: exitSelector];
            
            #pragma clang diagnostic pop
		}
	}	
}		

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Textures View Controller received a memory warning.");
}

@end
