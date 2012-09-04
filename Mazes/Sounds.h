//
//  Sounds.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Globals.h"
#import "DataAccess.h"
#import "Sound.h"

@interface Sounds : NSObject 
{
	int count;
}

@property (nonatomic) int count;

- (NSArray *)getSoundsSorted;

- (Sound *)getSoundForId: (int)soundId;

@end
