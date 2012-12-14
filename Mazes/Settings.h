//
//  Settings.h
//  Mazes
//
//  Created by Andre Muis on 9/3/12.
//
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
{
    NSUserDefaults *userDefaults;
}

@property (assign, nonatomic) BOOL useTutorial;

+ (Settings *)shared;

@end
