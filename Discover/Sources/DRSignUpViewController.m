//
//  DRSignUpViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 7/13/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRSignUpViewController.h"

@interface DRSignUpViewController ()

@end

@implementation DRSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fields = PFLogInFieldsDefault|PFLogInFieldsFacebook;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
