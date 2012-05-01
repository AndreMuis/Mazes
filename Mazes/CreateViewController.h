//
//  CreateViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Maze.h"
#import "GridView.h"

@interface CreateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	NSMutableArray *rowsArr;
	NSMutableArray *columnsArr;
	
	UIPickerView *pickerView;

	GridView *gridView;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) IBOutlet GridView *gridView;

- (IBAction)btnContinueTouchDown: (id)sender;

- (IBAction)btnMazesTouchDown: (id)sender;

@end
