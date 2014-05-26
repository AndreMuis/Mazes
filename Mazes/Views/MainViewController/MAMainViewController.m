//
//  MAMainViewController.m
//  Mazes
//
//  Created by Andre Muis on 12/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMainViewController.h"

#import "MAColors.h"
#import "MAMainScreenStyle.h"
#import "MAStyles.h"
#import "MAUtilities.h"

@interface MAMainViewController ()

@property (readwrite, strong, nonatomic) MAColors *colors;
@property (readwrite, strong, nonatomic) MAStyles *styles;

@property (readwrite, strong, nonatomic) UIViewController *currentViewController;

@property (readwrite, assign, nonatomic) BOOL isPerformingTransition;

@end

@implementation MAMainViewController

- (id)init
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _colors = [MAColors colors];
        _styles = [MAStyles styles];
        
        _isPerformingTransition = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = self.colors.redColor;
    
    [self addChildViewController: self.rootViewController];
    [self.view addSubview: self.rootViewController.view];
    [self.rootViewController didMoveToParentViewController: self];
    
    self.currentViewController = self.rootViewController;
}

- (void)transitionFromViewController: (UIViewController *)fromViewController
                    toViewController: (UIViewController *)toViewController
                          transition: (MATransitionType)transition
                          completion: (ViewControllerTransitionCompletionHandler)completionHandler
{
    self.isPerformingTransition = YES;

    self.currentViewController = nil;

    [self addChildViewController: toViewController];
    [fromViewController willMoveToParentViewController: nil];
    
    switch (transition)
    {
        case MATransitionNone:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(0.0,
                                                     0.0,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: 0
                                    animations: ^
             {
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;
                 
                 completionHandler();
                 
                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
            
        case MATransitionCrossDissolve:
        case MATransitionFlipFromTop:
        case MATransitionFlipFromBottom:
        case MATransitionFlipFromLeft:
        case MATransitionFlipFromRight:
        case MATransitionCurlUp:
        case MATransitionCurlDown:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(0.0,
                                                     0.0,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: (UIViewAnimationOptions)transition
                                    animations: ^
             {
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;

                 completionHandler();

                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
        case MATransitionTranslateBothUp:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(0.0,
                                                     toViewController.view.frame.size.height,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: 0
                                    animations: ^
             {
                 fromViewController.view.frame = CGRectMake(0.0,
                                                            -fromViewController.view.frame.size.height,
                                                            fromViewController.view.frame.size.width,
                                                            fromViewController.view.frame.size.height);
                 
                 toViewController.view.frame = CGRectMake(0.0,
                                                          0.0,
                                                          toViewController.view.frame.size.width,
                                                          toViewController.view.frame.size.height);
                 
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;

                 completionHandler();

                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
        case MATransitionTranslateBothDown:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(0.0,
                                                     -toViewController.view.frame.size.height,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: 0
                                    animations: ^
             {
                 fromViewController.view.frame = CGRectMake(0.0,
                                                            fromViewController.view.frame.size.height,
                                                            fromViewController.view.frame.size.width,
                                                            fromViewController.view.frame.size.height);
                 
                 toViewController.view.frame = CGRectMake(0.0,
                                                          0.0,
                                                          toViewController.view.frame.size.width,
                                                          toViewController.view.frame.size.height);
                 
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;

                 completionHandler();

                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
        case MATransitionTranslateBothLeft:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(toViewController.view.frame.size.width,
                                                     0.0,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: 0
                                    animations: ^
             {
                 fromViewController.view.frame = CGRectMake(-fromViewController.view.frame.size.width,
                                                            0.0,
                                                            fromViewController.view.frame.size.width,
                                                            fromViewController.view.frame.size.height);
                 
                 toViewController.view.frame = CGRectMake(0.0,
                                                          0.0,
                                                          toViewController.view.frame.size.width,
                                                          toViewController.view.frame.size.height);
                 
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;

                 completionHandler();

                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
        case MATransitionTranslateBothRight:
        {
            fromViewController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       fromViewController.view.frame.size.width,
                                                       fromViewController.view.frame.size.height);
            
            toViewController.view.frame = CGRectMake(-toViewController.view.frame.size.width,
                                                     0.0,
                                                     toViewController.view.frame.size.width,
                                                     toViewController.view.frame.size.height);
            
            [self transitionFromViewController: fromViewController
                              toViewController: toViewController
                                      duration: self.styles.mainScreen.transitionDuration
                                       options: 0
                                    animations: ^
             {
                 fromViewController.view.frame = CGRectMake(fromViewController.view.frame.size.width,
                                                            0.0,
                                                            fromViewController.view.frame.size.width,
                                                            fromViewController.view.frame.size.height);
                 
                 toViewController.view.frame = CGRectMake(0.0,
                                                          0.0,
                                                          toViewController.view.frame.size.width,
                                                          toViewController.view.frame.size.height);
                 
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
                 
                 self.currentViewController = toViewController;

                 completionHandler();

                 self.isPerformingTransition = NO;
             }];
            
            break;
        }
            
        default:
            [MAUtilities logWithClass: [self class]
                              message: @"transition set to an illegal value."
                           parameters: @{@"transition" : @(transition)}];
            
            self.currentViewController = nil;

            completionHandler();

            self.isPerformingTransition = NO;
            
            break;
    }
}

@end



