//
//  MAAlertController.m
//  Mazes
//
//  Created by Andre Muis on 3/23/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAAlertController.h"

@implementation MAAlertController

+ (void)showAlertWithPresentingViewController: (UIViewController *)presentingViewController
                                      message: (NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @""
                                                                   message: message
                                                            preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"OK"
                                                           style: UIAlertActionStyleCancel
                                                         handler: nil];

    [alert addAction: cancelAction];

    [presentingViewController presentViewController: alert
                                           animated: YES
                                         completion: nil];
} 

+ (void)showAlertWithPresentingViewController: (UIViewController *)presentingViewController
                                      message: (NSString *)message
                          confirmationHandler: (MAAlertControllerConfirmationHandler)confirmationHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @""
                                                                   message: message
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"Cancel"
                                                           style: UIAlertActionStyleCancel
                                                         handler: nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle: @"OK"
                                                            style: UIAlertActionStyleDestructive
                                                          handler: ^(UIAlertAction *action)
    {
        confirmationHandler();
    }];
    
    [alert addAction: cancelAction];
    [alert addAction: confirmAction];
    
    [presentingViewController presentViewController: alert
                                           animated: YES
                                         completion: nil];
}

@end












