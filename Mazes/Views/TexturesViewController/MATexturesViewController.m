//
//  MATexturesViewController.m
//  Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATexturesViewController.h"

#import "MAColors.h"
#import "MADesignScreenStyle.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATexture.h"

@interface MATexturesViewController ()

@property (readwrite, strong, nonatomic) MATextureManager *textureManager;
@property (readwrite, strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MATexturesViewController

- (id)initWithTextureManager: (MATextureManager *)textureManager
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _textureManager = textureManager;
        _styles = [MAStyles styles];
    }
    
    return self;
}

- (void)setup
{
    self.preferredContentSize = CGSizeMake(self.styles.designScreen.texturesPopoverWidth,
                                           self.styles.designScreen.texturesPopoverHeight);
    
    self.view.backgroundColor = self.styles.designScreen.texturesViewBackgroundColor;
    
    float padding = (self.styles.designScreen.texturesPopoverWidth - self.styles.designScreen.texturesPerRow * self.styles.designScreen.textureImageLength) /
                    (self.styles.designScreen.texturesPerRow + 1);
    
    int row = 1, column = 1;
    float x = 0.0, y = 0.0;
    for (MATexture *texture in [self.textureManager sortedByKindThenOrder])
    {
        if (column > self.styles.designScreen.texturesPerRow)
        {
            column = 1;
            row = row + 1;
        }
        
        x = padding + (column - 1) * (self.styles.designScreen.textureImageLength + padding);
        y = padding + (row - 1) * (self.styles.designScreen.textureImageLength + padding);
        
        UIImage *image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        
        imageView.tag = [[self.textureManager all] indexOfObject: texture];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(x,
                                     y,
                                     self.styles.designScreen.textureImageLength,
                                     self.styles.designScreen.textureImageLength);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
        [imageView addGestureRecognizer: tapGestureRecognizer];
        
        [self.scrollView addSubview: imageView];
        
        column = column + 1;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.styles.designScreen.texturesPopoverWidth,
                                             padding + row * (self.styles.designScreen.textureImageLength + padding));
}

- (void)handleTapFrom: (UITapGestureRecognizer *)tapGestureRecognizer
{
    MATexture *selectedTexture = [[self.textureManager all] objectAtIndex: tapGestureRecognizer.view.tag];
    
    self.textureSelectedHandler(selectedTexture);
}

@end



















