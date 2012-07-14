//
//  DRItemViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemViewController.h"

@interface DRItemViewController ()
@property (nonatomic, retain, readwrite) NSArray *conversationArray;
@property (nonatomic, retain, readwrite) PFObject *itemMessages;
@property (nonatomic, assign, readwrite) BOOL dataIsReady;
- (void)_loadEntireConversation:(PFObject *)messages;
- (void)_setStateIsLoading:(BOOL)isLoading;
- (void)_showConversationWithUsers:(NSArray *)users;
@end

@implementation DRItemViewController
@synthesize item = _item;
@synthesize itemMessages = _itemMessages;
@synthesize activityIndicator = _activityIndicator;
@synthesize tableView = _tableView;
@synthesize dataIsReady = _dataIsReady;
@synthesize conversationArray = _conversationArray;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.conversationArray = nil;
    self.itemMessages = nil;
    self.item = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSParameterAssert(self.item);
    
    self.tableView.hidden = YES;

    [self _setStateIsLoading:YES];
    
    self.itemMessages = [self.item objectForKey:@"messages"];
    NSParameterAssert(self.itemMessages);
    // @todo is it worth while to handle case where itemConversation isnt in local cache? The previous query gaurentees it...... hopefully.
    
    [self _loadEntireConversation:self.itemMessages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDelegate


#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.dataIsReady == YES )
    {
        return [self.conversationArray count];
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.dataIsReady == YES )
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdent = @"cellIdent";
    UITableViewCell* cell = nil;
    
    // Create the cell
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdent];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdent]autorelease];
    }
    
    // @todo dynamic height cells
    
    NSDictionary *objectDict = [self.conversationArray objectAtIndex:indexPath.row];
    NSString *messageString = [objectDict objectForKey:@"message"];
    
    /*
    // todo this doesn't work. query returns nil object. Create an array of all users that is stored alongside the conversation array
    NSString *userID = [objectDict objectForKey:@"owner"];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    query.cachePolicy = kPFCachePolicyCacheOnly;
    // todo check if PFError is returned (because cache policy is kPFCachePolicyCacheOnly)
    [query getObjectInBackgroundWithId:userID 
                                                        block:^(PFObject *object, NSError *error){
                                                            PFUser *user = (PFUser *)object;    // @todo is it ok to cast PFUser like this?
                                                            cell.textLabel.text = [NSString stringWithFormat:@"From %@", [user username]];
                                                        }];
     */
    
    // set message using detail label (for now)
    cell.detailTextLabel.text = messageString;
    
    
    return cell;
}

#pragma mark -
#pragma mark Private

- (void)_showConversationWithUsers:(NSArray *)users
{
//    NSArray *convoArray = [self.itemMessages objectForKey:@"conversation"];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[convoArray count]];
    
    self.conversationArray = [self.itemMessages objectForKey:@"conversation"];
    NSParameterAssert(self.conversationArray);
    self.dataIsReady = YES;
    
    NSLog(@"Data is ready. conversation array = %@", self.conversationArray);
    
    // assert that message is loaded & that all users for each message have also been loaded
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)_setStateIsLoading:(BOOL)isLoading
{
    if ( isLoading == YES )
    {
        [self.activityIndicator startAnimating];
    }
    else 
    {
        [self.activityIndicator stopAnimating];
    }
}

- (void)_loadEntireConversation:(PFObject *)messages
{
    // decode conversation
    NSArray *conversation = [messages objectForKey:@"conversation"];
    NSParameterAssert(conversation);
    
    // get all user ids from conversation
    NSMutableDictionary *allIDSHash = [[NSMutableDictionary alloc] init];   // @todo wasteful way to keep track of all unique ids
    [conversation enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop)
     {
         NSCParameterAssert([obj isKindOfClass:[NSDictionary class]] == YES);
         NSString *userID = [obj objectForKey:@"owner"];
         [allIDSHash setValue:@"" forKey:userID];
     }]; 
    
    NSArray *allUserIDS = [allIDSHash allKeys];
    
    NSLog(@"Querying for %d user IDS: %@", [allUserIDS count], allUserIDS);
    
    // Generate the query
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"objectID" containedIn:allUserIDS];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         NSLog(@"Query finished. Error = %@", (error == nil) ? @"NO":@"YES");
         
         [self _setStateIsLoading:NO];
         
         if ( error != nil )
         {
             NSLog(@"Error: %@", [error description]);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Failed to load conversation. Try again later!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok."
                                                   otherButtonTitles:nil];
             [alert show];
             [alert release];
         }
         else
         {
             [self _showConversationWithUsers:objects];
         }
     }];
}

@end
