//
//  DataAccess.h
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@interface DataAccess : NSObject <RKObjectLoaderDelegate>

- (void)getVersion;

@end
