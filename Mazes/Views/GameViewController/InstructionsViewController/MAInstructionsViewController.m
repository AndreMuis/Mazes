//
//  MAInstructionsViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/15/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAInstructionsViewController.h"

#import "MAStyles.h"
#import "MAGameScreenStyle.h"

@interface MAInstructionsViewController ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MAInstructionsViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _styles = [MAStyles styles];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = self.styles.gameScreen.instructionsBackgroundColor;
	self.label.textColor = self.styles.gameScreen.instructionsTextColor;
}

@end
