//
//  MATopMazeTableViewCellDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MATopMazeTableViewCell;

@protocol MATopMazeTableViewCellDelegate <NSObject>

@required
- (void)topMazeTableViewCell: (MATopMazeTableViewCell *)topMazeTableViewCell
             didUpdateRating: (float)rating
               forMazeWithId: (NSString *)mazeId
                        name: (NSString *)mazeName;

@end

