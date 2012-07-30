//
//  DRItemCreateViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemCreateViewController.h"
#import "DRPickLocationViewController.h"
#import "CSPlaceHolderTextView.h"

///////////////////////////////////////////////////////////////

@interface DRItemCreateViewController ()
- (void)_rightBarButtonItemWasPressed:(id)sender;
- (void)_showLeftCancelButton;
- (void)_pushNewMessage:(NSString *)message channelID:(NSString *)channelID;
- (void)_subscribeToChannel:(NSString *)channelID;

@property (nonatomic, retain, readwrite) PFGeoPoint *location;

@end

///////////////////////////////////////////////////////////////

@implementation DRItemCreateViewController
@synthesize location = _location;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize delegate = _delegate;
@synthesize parentObject = _parentObject;
@synthesize addLocationButton = _addLocationButton;
@synthesize keyboardAccessoryView = _keyboardAccessoryView;
@synthesize locationRequired = _locationRequired;

#pragma mark -
#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Talk";
        self.locationRequired = YES;
    }
    return self;
}

- (void)dealloc
{
    self.location = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(_rightBarButtonItemWasPressed:)] autorelease];    
    
    self.descriptionTextView.inputAccessoryView = self.keyboardAccessoryView;
    [self.descriptionTextView setPlaceholder:@"Say something..."];
    
        [self.descriptionTextView becomeFirstResponder];
    /// @todo The descriptionTextView needs to resize based on keyboard visible or not
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
#pragma mark DRPickLocationViewControllerDelegate

- (void)DRPickLocationViewController:(DRPickLocationViewController *)controller didPickLocation:(id)location
{
    NSLog(@"%s called", __FUNCTION__);
    NSAssert([location isKindOfClass:[PFGeoPoint class]] == YES, @"invalid class");
    self.location = location;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Public

- (IBAction)addLocationButtonWasPressed:(id)sender
{
    DRPickLocationViewController *picker = [[DRPickLocationViewController alloc] init];
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
    [picker release];
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
    
    [self.descriptionTextView resignFirstResponder];
}

- (void)_rightBarButtonItemWasPressed:(id)sender
{
    
    NSString *subject = nil;
    NSString *message = self.descriptionTextView.text;
        
    // validate
    if (( message == nil ) || ( message.length < 1 ))
    {
        NSLog(@"Error. not enough text (description)");
        return;
    }
    if ( self.parentObject == nil )
    {
        // get subject
        NSRange range = [message rangeOfString:@"\n"];
        if (( range.length == 0 ) || ( range.location < 1 ))
        {
            NSLog(@"Error. no subject");
            return;
        }
        subject = [message substringToIndex:range.location];
        message = [message substringFromIndex:range.location+1];
        if (( subject.length < 1 ) || ( message.length < 1 ))
        {
            NSLog(@"Error. subject parse message too short");
            return;
        }
    }
    if (( self.locationRequired == YES ) && ( self.location == nil ))
    {
        NSLog(@"Error. no location");
        return;
    }
    
    // disable UI
    [(UIBarButtonItem *)sender setEnabled:NO];

    // create object
    PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
    
    if ( self.parentObject == nil )
    {
        // create new message and new item
        PFObject *newItem = [PFObject objectWithClassName:@"Item"];
        
        NSParameterAssert(self.location);
        [newItem setObject:self.location forKey:kDRItemTableKeyLocation];
        [newItem setObject:subject forKey:kDRItemTableKeyTitle];
        [newItem setObject:[PFUser currentUser] forKey:kDRItemTableKeyCreator];
        [newItem saveEventually];
        
        [newMessage setObject:newItem forKey:kDRMessageTableKeyParent];
    }
    else
    {
        // existing object (continuing conversation)
        [newMessage setObject:self.parentObject forKey:kDRMessageTableKeyParent];
    }
    [newMessage setObject:[PFUser currentUser] forKey:kDRMessageTableKeyCreator];
    [newMessage setObject:message forKey:kDRMessageTableKeyText];
    if ( self.location != nil )
    {
        [newMessage setObject:self.location forKey:kDRMessageTableKeyLocation];
    }
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if ( succeeded == YES )
         {
             NSLog(@"Message created!");
             if ( self.delegate )
             {
                 [self.delegate DRItemCreateViewController:self didCreateItem:newMessage];
             }
             //          [self _pushNewMessage:message channelID:objectID];
             //          [self _subscribeToChannel:objectID];
         }
         else
         {
             NSLog(@"Failed to send message");
         }
     }
     ];
}

- (void)_subscribeToChannel:(NSString *)channelID
{
    [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"item-%@", channelID]];
}

- (void)_pushNewMessage:(NSString *)message channelID:(NSString *)channelID
{
    // Send a push notification
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
//                          @"5", @"score_REDSOX",
//                          @"0", @"score_YANKEES",
//                          @"4th", @"inning",
                          nil];
    
    NSParameterAssert(channelID);
    NSString *channelName = [NSString stringWithFormat:@"item-%@", channelID];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannels:[NSArray arrayWithObjects:channelName, nil]];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:60*60*4];
    [push setData:data];
    [push sendPushInBackground];
}
@end
