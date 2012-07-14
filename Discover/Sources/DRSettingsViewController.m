//
//  DRSettingsViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRSettingsViewController.h"

@interface DRSettingsViewController ()
- (void)_updateUserInfoInView;
@end

@implementation DRSettingsViewController
@synthesize usernameLabel = _usernameLabel;


// @todo Lots of state logic missing.
// prevent login if already logged in, etc...

#pragma mark -
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _updateUserInfoInView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"%s called", __FUNCTION__);
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"%s called", __FUNCTION__);
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    NSLog(@"%s called", __FUNCTION__);
    return YES;
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"%s called", __FUNCTION__);    
}

#pragma mark -
#pragma mark PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"%s called", __FUNCTION__);
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"%s called", __FUNCTION__);
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    NSLog(@"%s called", __FUNCTION__);
    return YES;
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"%s called", __FUNCTION__);
}

#pragma mark -
#pragma mark Public

- (IBAction)loginButtonWasPressed:(id)sender
{
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentModalViewController:logInController animated:YES];
}

- (IBAction)signUpButtonWasPressed:(id)sender
{
    PFSignUpViewController *signUpController = [[PFSignUpViewController alloc] init];
    signUpController.delegate = self;
    [self presentModalViewController:signUpController animated:YES];
}

- (IBAction)logoutButtonWasPressed:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if ( [PFAnonymousUtils isLinkedWithUser:currentUser] == NO )    // make sure user is actually logged in
    {
        [PFUser logOut];
        [self _updateUserInfoInView];
    }
}

#pragma mark -
#pragma mark Private

- (void)_updateUserInfoInView
{
    PFUser *currentUser = [PFUser currentUser];
    if ( [PFAnonymousUtils isLinkedWithUser:currentUser] == YES )
    {
        self.usernameLabel.text = @"Not signed in";
    }
    else
    {
        self.usernameLabel.text = [currentUser username];
    }
}

@end
