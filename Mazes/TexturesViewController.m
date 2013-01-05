//
//  TexturesViewController.m
//  Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "TexturesViewController.h"

#import "Textures.h"
#import "Texture.h"

@implementation TexturesViewController

- (void)loadView
{
	self.view = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0, 0.0, [Styles shared].editView.popoverTexturesWidth, [Styles shared].editView.popoverTexturesHeight)];
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
	self.view.backgroundColor = [Styles shared].editView.viewTexturesBackgroundColor;
	
	NSArray *textures = [[Textures shared] sortedByKindThenOrder];
	
	float padding = ([Styles shared].editView.popoverTexturesWidth - [Styles shared].editView.texturesPerRow * [Styles shared].editView.textureImageLength) / ([Styles shared].editView.texturesPerRow + 1);
	
	int row = 1, column = 1;
	float x = 0.0, y = 0.0;
	for (Texture *texture in textures)
	{
		if (column > [Styles shared].editView.texturesPerRow)
		{
			column = 1;
			row = row + 1;
		}
		
		x = padding + (column - 1) * ([Styles shared].editView.textureImageLength + padding);
		y = padding + (row - 1) * ([Styles shared].editView.textureImageLength + padding);
		
		UIImage *image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
		
		CGRect imageViewFrame = CGRectMake(x, y, [Styles shared].editView.textureImageLength, [Styles shared].editView.textureImageLength);
		
		texture.imageViewFrame = imageViewFrame;
		
		imageView.frame = imageViewFrame;
		
		[self.view addSubview: imageView];
		
		column = column + 1;
	}
	
	UIScrollView *texturesView = (UIScrollView *)self.view;
	texturesView.contentSize = CGSizeMake([Styles shared].editView.popoverTexturesWidth, padding + row * ([Styles shared].editView.textureImageLength + padding));	
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint touchPoint = [recognizer locationInView: self.view];

	NSArray *textures = [[Textures shared] sortedByKindThenOrder];

	for (Texture *texture in textures)
	{
		if (CGRectContainsPoint(texture.imageViewFrame, touchPoint) == YES)
		{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
			[self.textureDelegate performSelector: self.textureSelector withObject: [NSNumber numberWithInt: texture.id]];
			
			[self.exitDelegate performSelector: self.exitSelector];
            
            #pragma clang diagnostic pop
		}
	}	
}		

@end
