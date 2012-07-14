//
//  DRItemCreateViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemCreateViewController.h"
#import "DRPickLocationViewController.h"

@interface DRItemCreateViewController ()
- (void)_rightBarButtonItemWasPressed:(id)sender;
- (void)_showLeftCancelButton;
@end

@implementation DRItemCreateViewController
@synthesize descriptionTextView = _descriptionTextView;
@synthesize titleTextField = _titleTextField;

#pragma mark -
#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Create Something";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(_rightBarButtonItemWasPressed:)] autorelease];
    
//    [self.titleTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self _showLeftCancelButton];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self _showLeftCancelButton];    
}

#pragma mark -
#pragma mark Private

- (void)_showLeftCancelButton
{
    if ( self.navigationItem.leftBarButtonItem == nil )
    {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(_leftBarButtonItemWasPressed:)] autorelease];
    }
}

- (void)_leftBarButtonItemWasPressed:(id)sender
{
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (void)_rightBarButtonItemWasPressed:(id)sender
{
    if (( self.titleTextField.text == nil ) || ( self.titleTextField.text.length < 1 ) || ( self.descriptionTextView.text == nil ) || ( self.descriptionTextView.text.length < 1 ))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You didn't type enough"
                                                       delegate:nil
                                              cancelButtonTitle:@"My mistake. I am so sorry."
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [(UIBarButtonItem *)sender setEnabled:NO];
    
    DRPickLocationViewController *locationPicker = [[DRPickLocationViewController alloc] init];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.titleTextField.text, @"title", self.descriptionTextView.text, @"description", nil] autorelease];
    locationPicker.itemDictionary = dict;
    
    [self.navigationController pushViewController:locationPicker animated:YES];
    [locationPicker release];
}

@end
