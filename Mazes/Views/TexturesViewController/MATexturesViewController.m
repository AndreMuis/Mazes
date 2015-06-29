//
//  MATexturesViewController.m
//  Mazes
//
//  Created by Andre Muis on 2/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATexturesViewController.h"

#import "MAColors.h"
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
}

- (void)handleTapFrom: (UITapGestureRecognizer *)tapGestureRecognizer
{
    MATexture *selectedTexture = [[self.textureManager all] objectAtIndex: tapGestureRecognizer.view.tag];
    
    self.textureSelectedHandler(selectedTexture);
}

@end



















