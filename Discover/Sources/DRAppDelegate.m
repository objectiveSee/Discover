//
//  DRAppDelegate.m
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRAppDelegate.h"

#import "DRItemListViewController.h"
#import "DRSettingsViewController.h"
#import "DRItemCreateViewController.h"
#import "DRSignUpViewController.h"
#import "DRUtility.h"

@interface DRAppDelegate ()
- (void)_setApplicationAppearence;
@end

@implementation DRAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |             
     UIRemoteNotificationTypeSound];
    
    [Parse setApplicationId:@"netrY86MUvdf58YwPFIa8HLo9H1TL2awNznfmA4D"
                  clientKey:@"qIRJ9aHOHv8gW0ZdcZV3rukkbV1oaMvoU3HsfcaO"];
    [PFFacebookUtils initializeWithApplicationId:@"174303732694752"];
    [PFUser enableAutomaticUser];
    
    [self _setApplicationAppearence];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [self _showSignUpOrMainApp];
    
    NSParameterAssert(self.window.rootViewController);

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, "" 
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
        NSLog(@"Push notifications don't work in the simulator!");
    } else {
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"TODO %s", __FUNCTION__);
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark -
#pragma mark Public

- (void)showMainApplication
{
    // Tab 1
    UIViewController *viewController1 = [[[DRItemListViewController alloc] init] autorelease];
    UINavigationController *navigationController1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    
    // Tab 2
    UIViewController *viewController2 = [[[DRItemCreateViewController alloc] init] autorelease];
    UINavigationController *navigationController2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    
    // Tab 3
    UIViewController *viewController3 = [[[DRSettingsViewController alloc] init] autorelease];
    UINavigationController *navigationController3 = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2,navigationController3,nil];
    
    self.window.rootViewController = self.tabBarController;
    
    [self.tabBarController setSelectedIndex:1];
    
    [[DRUtility sharedUtility] syncCurrentUserFacebook];
}

- (void)showSignUp
{
    DRSignUpViewController *signUpController = [[DRSignUpViewController alloc] init];
    self.window.rootViewController = signUpController;
    [signUpController release];
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self _showSignUpOrMainApp];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self _showSignUpOrMainApp];
}

#pragma mark -
#pragma mark Private

- (void)_showSignUpOrMainApp
{
    PFUser *currentUser = [PFUser currentUser];
    if (([PFAnonymousUtils isLinkedWithUser:currentUser]) || ( currentUser == nil )) {
        // user must sign in
        [self showSignUp];
    }
    else
    {
        // user is signed in
        [self showMainApplication];
        [[PFUser currentUser] incrementKey:@"RunCount"];
        [[PFUser currentUser] saveInBackground];
    }
}

static const CGFloat kDRMinVersionSupportsUIAppearence = 5.0f;
- (void)_setApplicationAppearence
{
    // OS-specific properties
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ( version >= kDRMinVersionSupportsUIAppearence )
    {        
        // Customize the navigation bar appearence
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundNavigationBar"] 
                                           forBarMetrics:UIBarMetricsDefault];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundTabBar"]];
        
        // customize barbutton items & buttons in navigation bar
        [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBar.png"] forState:UIControlStateNormal];
        [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarSelected.png"] forState:UIControlStateHighlighted];
        [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"ButtonBack.png"]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"ButtonBackSelected.png"]
                                                          forState:UIControlStateSelected
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f],UITextAttributeTextColor, 
                                                              [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor, 
                                                              [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],UITextAttributeTextShadowOffset, 
                                                              nil] forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"Warning. Device version (%f) does not support UIAppearence", version);
    }
}


@end
