//
//  Lost & Found app delegate
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LFDelegate.h"
#import "LFViewController.h"
#import "LFLoginViewController.h"
#import "LFSearchViewController.h"


@interface LFDelegate () <LFLoginViewControllerDelegate, LFSearchViewControllerDelegate>

@end

@implementation LFDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"AL7v42Pv5MskAy3bsAFGNriGNTpY6af8VwshoSnu"
                  clientKey:@"RrWnOBRZTFX9aGsWAkrXsi3wiUGcJWRaGt99xKvn"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    
    // Caches user when they sign in so they dont need to sign in every time :)
    if([PFUser currentUser]){
        [self presentSearchViewController];
    }
    
    // Log in screen if not logged in, can register from there :)
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
    [self presentSearchViewController];
}

-(void)presentSearchViewController {
    LFSearchViewController *searchViewController = [[LFSearchViewController alloc] initWithNibName:nil bundle:nil];
    searchViewController.delegate = self;
    [self.navigationController setViewControllers:@[searchViewController] animated:YES];
}

@end
