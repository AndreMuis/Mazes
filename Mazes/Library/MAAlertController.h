//
//  MAAlertController.h
//  Mazes
//
//  Created by Andre Muis on 3/23/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void (^MAAlertControllerConfirmationHandler)();

@interface MAAlertController : NSObject

+ (void)showAlertWithPresentingViewController: (UIViewController *)presentingViewController
                                      message: (NSString *)message;

+ (void)showAlertWithPresentingViewController: (UIViewController *)presentingViewController
                                      message: (NSString *)message
                          confirmationHandler: (MAAlertControllerConfirmationHandler)confirmationHandler;

@end
