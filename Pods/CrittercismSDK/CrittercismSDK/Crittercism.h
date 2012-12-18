//
//  Crittercism.h
//  Crittercism-iOS
//
//  Created by Robert Kwok on 8/15/10.
//  Copyright 2010-2012 Crittercism Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CrittercismDelegate <NSObject>

@optional
- (void)crittercismDidClose;
- (void)crittercismDidCrashOnLastLoad;
@end

@interface Crittercism : NSObject {
  // tracks our HTTP connections
  CFMutableDictionaryRef connectionMap;
  id <CrittercismDelegate> delegate;
  BOOL didCrashOnLastLoad;
}

@property(retain) id <CrittercismDelegate> delegate;
@property(assign) BOOL didCrashOnLastLoad;

//
// Methods for Enabling Crittercism
//
// You must call one of these before using any other Crittercism functionality

+ (void)enableWithAppID:(NSString *)appId;

// Designated "initializer"
+ (void)enableWithAppID:(NSString *)appId
            andDelegate:(id <CrittercismDelegate>)critterDelegate;

+ (Crittercism *)sharedInstance;

// Retrieve your app id
+ (NSString *)getAppID;

// Disable or enable all communication with Crittercism servers.
// If called to disable (status == YES), any pending crash reports will be
// purged, and feedback will be reset (if using the forum feature.)
+ (void)setOptOutStatus:(BOOL)status;

// Retrieve currently stored opt out status.
+ (BOOL)getOptOutStatus;

// Record an exception that you purposely caught via Crittercism.
//
// Note: Crittercism limits logging handled exceptions to once per minute. If
// you've logged an exception within the last minute, we buffer the last five
// exceptions and send those after a minute has passed.
+ (BOOL)logHandledException:(NSException *)exception;

// Leave a breadcrumb for the current run of your app. If the app ever crashes,
// these breadcrumbs will be uploaded along with that crash report to
// Crittercism's servers.
+ (void)leaveBreadcrumb:(NSString *)breadcrumb;

//
// Methods for User Metadata
//

+ (void)setAge:(int)age;
+ (void)setGender:(NSString *)gender;
+ (void)setUsername:(NSString *)username;
+ (void)setEmail:(NSString *)email;
// Set an arbitrary key/value pair in the User Metadata
+ (void)setValue:(NSString *)value forKey:(NSString *)key;

////////////////////////////////////////////////////////////////////////////////
// DEPRECATED METHODS
////////////////////////////////////////////////////////////////////////////////

//
// Initializers - Will be removed in a future release. Please change your code
// to use one of the enable* methods
//

+ (void)initWithAppID:(NSString *)appId __attribute__((deprecated));

+ (void)initWithAppID:(NSString *)appId
    andMainViewController:(UIViewController *)viewController
    __attribute__((deprecated));

+ (void)initWithAppID:(NSString *)appId
    andMainViewController:(UIViewController *)viewController
    andDelegate:(id)critterDelegate
    __attribute__((deprecated));

// Deprecated in v3.3.1 - key and secret are no longer needed
+ (void)initWithAppID:(NSString *)appId
    andKey:(NSString *)keyStr
    andSecret:(NSString *)secretStr
    __attribute__((deprecated));

// Deprecated in v3.3.1 - key and secret are no longer needed
+ (void)initWithAppID:(NSString *)appId
    andKey:(NSString *)keyStr
    andSecret:(NSString *)secretStr
    andMainViewController:(UIViewController *)viewController
    __attribute__((deprecated));

// This method does nothing and will be removed in a future release.
+ (void)configurePushNotification:(NSData *)deviceToken
    __attribute__((deprecated));

@end
