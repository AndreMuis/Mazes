//
//  MACloud.m
//  Mazes
//
//  Created by Andre Muis on 1/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MACloud.h"

@interface MACloud ()

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
        
        if ([[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].count == 0)
        {
            [self setUserName: nil];
            [self setPassword: nil];
        }
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
    for (NSString *key in [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].allKeys)
    {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey: key];
    }
}

- (NSString *)userName
{
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey: self.userNameKey];
}

- (void)setUserName: (NSString *)userName
{
    [[NSUbiquitousKeyValueStore defaultStore] setObject: userName forKey: self.userNameKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (NSString *)password
{
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey: self.passwordKey];
}

- (void)setPassword: (NSString *)password
{
    [[NSUbiquitousKeyValueStore defaultStore] setObject: password forKey: self.passwordKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

@end




















