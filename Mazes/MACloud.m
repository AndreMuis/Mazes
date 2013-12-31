//
//  MACloud.m
//  Mazes
//
//  Created by Andre Muis on 1/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MACloud.h"

@interface MACloud ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (strong, nonatomic) NSString *userNameKey;
@property (strong, nonatomic) NSString *passwordKey;

@end

@implementation MACloud

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _userNameKey = @"userNameKey";
        _passwordKey = @"passwordKey";
        
        #if TARGET_IPHONE_SIMULATOR
        
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        #else
        
        _userDefaults = nil;
        
        if ([[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].count == 0)
        {
            [self setUserName: nil];
            [self setPassword: nil];
        }

        #endif
    }
    
    return self;
}

- (BOOL)isAvailable
{
    NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier: nil];
    
    if (url != nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)clear
{
    #if TARGET_IPHONE_SIMULATOR
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [self.userDefaults removePersistentDomainForName: appDomain];
    
    #else
    
    for (NSString *key in [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].allKeys)
    {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey: key];
    }

    #endif
}

- (NSString *)userName
{
    #if TARGET_IPHONE_SIMULATOR

    return [self.userDefaults stringForKey: self.userNameKey];

    #else
    
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey: self.userNameKey];
    
    #endif
}

- (void)setUserName: (NSString *)userName
{
    #if TARGET_IPHONE_SIMULATOR
    
    [self.userDefaults setObject: userName forKey: self.userNameKey];
    [self.userDefaults synchronize];
    
    #else
    
    [[NSUbiquitousKeyValueStore defaultStore] setObject: userName forKey: self.userNameKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    #endif
}

- (NSString *)password
{
    #if TARGET_IPHONE_SIMULATOR
    
    return [self.userDefaults stringForKey: self.passwordKey];
    
    #else
    
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey: self.passwordKey];
    
    #endif
}

- (void)setPassword: (NSString *)password
{
    #if TARGET_IPHONE_SIMULATOR
    
    [self.userDefaults setObject: password forKey: self.passwordKey];
    [self.userDefaults synchronize];
    
    #else
    
    [[NSUbiquitousKeyValueStore defaultStore] setObject: password forKey: self.passwordKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    #endif
}

@end




















