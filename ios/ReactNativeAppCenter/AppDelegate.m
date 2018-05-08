/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import <AppCenterReactNativeCrashes/AppCenterReactNativeCrashes.h>
#import <AppCenterReactNativeAnalytics/AppCenterReactNativeAnalytics.h>
#import <AppCenterReactNative/AppCenterReactNative.h>
@import AppCenter;
@import AppCenterDistribute;

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  [AppCenterReactNativeCrashes registerWithAutomaticProcessing];  // Initialize AppCenter crashes

  [AppCenterReactNativeAnalytics registerWithInitiallyEnabled:true];  // Initialize AppCenter analytics

  [MSAppCenter start:@"a70bd2ab-0e3b-48d3-833b-e9fa44a03974" withServices:@[[MSDistribute class]]];
  
  [AppCenterReactNative register];  // Initialize AppCenter 

  [MSDistribute setDelegate:self];
  
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ReactNativeAppCenter"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}
  
- (BOOL)distribute:(MSDistribute *)distribute releaseAvailableWithDetails:(MSReleaseDetails *)details {
  
  // Your code to present your UI to the user, e.g. an UIAlertController.
  UIAlertController *alertController = [UIAlertController
                                        alertControllerWithTitle:@"Update available."
                                        message:@"Do you want to update?"
                                        preferredStyle:UIAlertControllerStyleAlert];
  
  [alertController
   addAction:[UIAlertAction actionWithTitle:@"Update"
                                      style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction *action) {
                                      [MSDistribute notifyUpdateAction:MSUpdateActionUpdate];
                                    }]];
  
  [alertController
   addAction:[UIAlertAction actionWithTitle:@"Postpone"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                      [MSDistribute notifyUpdateAction:MSUpdateActionPostpone];
                                    }]];
  
  // Show the alert controller.
  [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
  return YES;
}

@end
