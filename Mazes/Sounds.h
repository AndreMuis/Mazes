//
//  Sounds.h
//  iPad_Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

#import "WebServices.h"

@class Sound;

@interface Sounds : NSObject <MAWebServicesGetSoundsDelegate>
{
    WebServices *webServices;
}

@property (assign, nonatomic, readonly) BOOL loaded;
@property (assign, nonatomic, readonly) int count;

+ (Sounds *)shared;

- (void)download;

- (NSArray *)getSoundsSorted;

- (Sound *)getSoundWithId: (int)id;

@end
