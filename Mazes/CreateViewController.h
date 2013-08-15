//
//  CreateViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAViewController.h"

@class GridView;

@interface CreateViewController : MAViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet GridView *gridView;

+ (CreateViewController *)shared;

- (void)reset;

- (IBAction)continueButtonTouchDown: (id)sender;

- (IBAction)mazesButtonTouchDown: (id)sender;

@end
