//
//  CreateViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Maze.h"
#import "GridView.h"

@interface CreateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    Maze *maze;
    
	NSMutableArray *rowsArr;
	NSMutableArray *columnsArr;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet GridView *gridView;

- (IBAction)btnContinueTouchDown: (id)sender;

- (IBAction)btnMazesTouchDown: (id)sender;

@end
