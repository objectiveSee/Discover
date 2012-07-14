//
//  DRAppDelegate.h
//  Discover
//  test comment test
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

- (void)showMainApplication;

- (void)showSignUp;

@end
