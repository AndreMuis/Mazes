//
//  MAMainViewController.m
//  Mazes
//
//  Created by Andre Muis on 12/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMainViewController.h"

#import "MAUtilities.h"
#import "MATopMazesViewController.h"
#import "MainViewStyle.h"
#import "Styles.h"

@implementation MAMainViewController

+ (MAMainViewController *)shared
{
	static MAMainViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
            instance = [[MAMainViewController alloc] initWithNibName: @"MainViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self addChildViewController: [MATopMazesViewController shared]];
    [self.view addSubview: [MATopMazesViewController shared].view];
    [[MATopMazesViewController shared] didMoveToParentViewController: self];
}

- (void)transitionFromViewController: (UIViewController *)fromViewController
                    toViewController: (UIViewController *)toViewController
                          transition: (MATransitionType)transition
{
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
                                      duration: [Styles shared].mainView.transitionDuration
                                       options: 0
                                    animations: ^
             {
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
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
                                      duration: [Styles shared].mainView.transitionDuration
                                       options: (UIViewAnimationOptions)transition
                                    animations: ^
             {
             }
                                    completion: ^(BOOL finished)
             {
                 [fromViewController removeFromParentViewController];
                 [toViewController didMoveToParentViewController: self];
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
                                      duration: [Styles shared].mainView.transitionDuration
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
                                      duration: [Styles shared].mainView.transitionDuration
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
                                      duration: [Styles shared].mainView.transitionDuration
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
                                      duration: [Styles shared].mainView.transitionDuration
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
             }];
            
            break;
        }
            
        default:
            [MAUtilities logWithClass: [self class] format: @"transition set to an illegal value: %d", transition];
            
            break;
    }
}

@end



