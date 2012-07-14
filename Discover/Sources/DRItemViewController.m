//
//  DRItemViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemViewController.h"
#import "DRItemTableViewCell.h"

#import "UIView+Origami.h"
#import "NSDate+Additions.h"

@interface DRItemViewController ()

@property ( nonatomic, retain, readwrite ) MKMapView *mapView;

- (void)_postButtonWasPressed:(id)sender;
@end

@implementation DRItemViewController
@synthesize item = _item;
@synthesize mapView = _mapView;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = @"Message";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)dealloc
{
    self.mapView.delegate = nil;
    self.mapView = nil;
    self.item = nil;
    [super dealloc];
}

/// todo unload map when memory warning & not current controller in window

#pragma mark -
#pragma mark UIViewController

static const CGFloat kDRMapHeight = 250.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tableview
    self.tableView.backgroundColor = [UIColor DRLightBackgroundColor];
    
    // tableview header
//    self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kDRMapHeight)] autorelease];
//    self.mapView.delegate = self;
//    self.tableView.tableHeaderView = self.mapView;

    // right button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Talk"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(_postButtonWasPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (( self.objects != nil ) && ( indexPath.row < [self.objects count] ))
    {
        id object = [self objectAtIndex:indexPath];
        NSParameterAssert(object);
        return [DRItemTableViewCell preferredHeightForObject:object width:tableView.frame.size.width];
    }
    return 44.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
//    v.backgroundColor = [UIColor redColor];
//    return [v autorelease];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}

#pragma mark - 
#pragma mark Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    NSLog(@"%s called", __FUNCTION__);
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    NSLog(@"%s called", __FUNCTION__);
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    NSParameterAssert(self.item);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query includeKey:@"creator"];
    
    [query whereKey:@"parent" equalTo:self.item];
    //    [query whereKey:@"location" nearGeoPoint:userGeoPoint];
    [query orderByAscending:@"updatedAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    DRItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DRItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.detailTextLabel.text = [object objectForKey:@"text"];
    
    PFUser *creator = [object objectForKey:@"creator"];
    NSParameterAssert(creator);
    cell.textLabel.text = [NSString stringWithFormat:@"From %@",[creator username]];
    
    NSParameterAssert(object.createdAt);
    cell.dateLabel.text = [object.createdAt recentDateAndTimeString];
        
    //    PFFile *thumbnail = [object objectForKey:@"thumbnail"];
    //    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //    cell.imageView.file = thumbnail;
    return cell;
}

#pragma mark -
#pragma mark DRItemCreateViewControllerDelegate

- (void)DRItemCreateViewController:(DRItemCreateViewController *)controller didCreateItem:(id)item
{
    NSLog(@"%s called", __FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
    
    [self loadObjects]; // refreshes page?
}

#pragma mark -
#pragma mark Private

- (void)_postButtonWasPressed:(id)sender
{
    NSParameterAssert(self.item);

    DRItemCreateViewController *itemCreateController = [[DRItemCreateViewController alloc] init];
    itemCreateController.delegate = self;
    itemCreateController.parentObject = self.item;
    [self.navigationController pushViewController:itemCreateController animated:YES];
    [itemCreateController release];  
}

@end
