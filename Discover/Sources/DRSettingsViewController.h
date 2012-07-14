//
//  DRSettingsViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRSettingsViewController : UIViewController <PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{
    UILabel *_usernameLabel;
}

@property (nonatomic, readonly) IBOutlet UILabel *usernameLabel;

- (IBAction)loginButtonWasPressed:(id)sender;

- (IBAction)signUpButtonWasPressed:(id)sender;

- (IBAction)logoutButtonWasPressed:(id)sender;

@end
