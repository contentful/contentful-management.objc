//
//  CMAAppDelegate.m
//  ManagementSDK
//
//  Created by CocoaPods on 07/14/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "CMAAppDelegate.h"
#import "CMAViewController.h"

@implementation CMAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc]
                                      initWithRootViewController:[CMAViewController new]];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
