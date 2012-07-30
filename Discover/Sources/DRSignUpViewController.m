//
//  DRSignUpViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 7/29/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRSignUpViewController.h"
#import "DRAppDelegate.h"

@interface DRSignUpViewController ()
@property (nonatomic, retain, readwrite) IBOutlet UIButton *fbButton;
@end

@implementation DRSignUpViewController
@synthesize fbButton = _fbButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.fbButton = nil;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Public

- (IBAction)facebookButtonWasPressed:(id)sender
{
    self.fbButton.enabled = NO;
    NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me", nil];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        BOOL wasSuccess = NO;
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            UIAlertView *v = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to login with Facebook" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [v show];
            [v release];
        } else if (user.isNew) {
            wasSuccess = YES;
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            wasSuccess = YES;
            NSLog(@"User logged in through Facebook!");
        }
        
        if ( wasSuccess == YES )
        {
            self.fbButton.hidden = YES;
            DRAppDelegate *delegate = (DRAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate showMainApplication];
        }
        else
        {
            self.fbButton.enabled = YES;
        }
    }];
}

@end
