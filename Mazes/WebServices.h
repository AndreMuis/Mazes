//
//  WebServices.h
//  Mazes
//
//  Created by Andre Muis on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@class Version;

@protocol GetVersionDelegate <NSObject>
@required
- (void)getVersionSucceededWithVersion: (Version *)version;
- (void)getVersionFailed;
@end

@protocol GetSoundsDelegate <NSObject>
@required
- (void)getSoundsSucceeded;
- (void)getSoundsFailed;
@end

@protocol GetTexturesDelegate <NSObject>
@required
- (void)getTexturesSucceeded;
- (void)getTexturesFailed;
@end

@interface WebServices : NSObject
{
    RKObjectManager *objectManager;;
}

- (void)getVersionWithDelegate: (id<GetVersionDelegate>)delegate;
- (void)getSoundsWithDelegate: (id<GetSoundsDelegate>)delegate;
- (void)getTexturesWithDelegate: (id<GetTexturesDelegate>)delegate;

@end
