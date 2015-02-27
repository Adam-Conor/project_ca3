//
//  ParseStarterProjectAppDelegate.m
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>

// If you want to use any of the UI components, uncomment this line
#import <ParseUI/ParseUI.h>

// If you are using Facebook, uncomment this line
// #import <ParseFacebookUtils/PFFacebookUtils.h>

// If you want to use Crash Reporting - uncomment this line
// #import <ParseCrashReporting/ParseCrashReporting.h>

#import "LFDelegate.h"
#import "LFViewController.h"
#import "LFLoginViewController.h"

@interface LFDelegate () <LFloginViewControllerDelegate>

@end

@implementation LFDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"AL7v42Pv5MskAy3bsAFGNriGNTpY6af8VwshoSnu"
                  clientKey:@"RrWnOBRZTFX9aGsWAkrXsi3wiUGcJWRaGt99xKvn"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    
    
    if([PFUser currentUser]){
        [self presentLoginViewController];
    }
    
    else [self presentLoginViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)presentLoginViewController {
    LFLoginViewController *viewController = [[LFLoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[viewController] animated:NO];
}

-(void)loginViewControllerDidLogin:(LFLoginViewController *)controller{
    //[self presentSearchViewController];
}

@end
