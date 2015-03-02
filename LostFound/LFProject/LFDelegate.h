//
//  LFAppDelegate.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITabBarController *tabController;

@end
