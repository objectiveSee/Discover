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
@synthesize delegate = _delegate;
@synthesize parentObject = _parentObject;

#pragma mark -
#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Post";
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(_rightBarButtonItemWasPressed:)] autorelease];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.parentObject != nil )
    {
        self.titleTextField.hidden = YES;   // hide if parent. only new items have title
    }
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
    // validate
    if (( self.descriptionTextView.text == nil ) || ( self.descriptionTextView.text.length < 1 ))
    {
        NSLog(@"Error. not enough text (description)");
        return;
    }
    if (( self.titleTextField.text == nil ) || ( self.titleTextField.text.length < 1 ))
    {
        if ( self.titleTextField.hidden == NO )
        {
            NSLog(@"Not enough text (title)");
            return;
        }
    }
    
    [(UIBarButtonItem *)sender setEnabled:NO];
    
    if ( self.parentObject != nil )
    {
        NSLog(@"Creating message with parent");
        PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
        [newMessage setObject:[PFUser currentUser] forKey:@"creator"];
        [newMessage setObject:self.descriptionTextView.text forKey:@"text"];
        [newMessage setObject:self.parentObject forKey:@"parent"];
    
        [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if ( succeeded == YES )
             {
                 NSLog(@"Message created!");
                 if ( self.delegate )
                 {
                     [self.delegate DRItemCreateViewController:self didCreateItem:newMessage];
                 }
             }
             else
             {
                 NSLog(@"Failed to send message");
             }
         }
         ];
    }
    else
    {
        NSLog(@"Creating a new item (no parent)");
        PFObject *newItem = [PFObject objectWithClassName:@"Item"];
        [newItem setObject:[PFUser currentUser] forKey:@"creator"];
        [newItem setObject:self.titleTextField.text forKey:@"title"];
        
        PFObject *firstMessage = [PFObject objectWithClassName:@"Message"];
        [firstMessage setObject:[PFUser currentUser] forKey:@"creator"];
//        [firstMessage setObject:geoPoint forKey:@"location"];
        [firstMessage setObject:self.descriptionTextView.text forKey:@"text"];
        [firstMessage setObject:newItem forKey:@"parent"];
        
        [firstMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if ( succeeded == YES )
             {
                 NSLog(@"New Item created!");
             }
             else
             {
                 NSLog(@"Failed to create item");
             }
         }
         ];
    }
    
    /**

    
    DRPickLocationViewController *locationPicker = [[DRPickLocationViewController alloc] init];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.titleTextField.text, @"title", self.descriptionTextView.text, @"description", nil] autorelease];
    locationPicker.itemDictionary = dict;
    
    [self.navigationController pushViewController:locationPicker animated:YES];
    [locationPicker release];
     */
}

@end
