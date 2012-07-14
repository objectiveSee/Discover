//
//  DRItemViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemViewController.h"
#import "DRItemTableViewCell.h"
#import "DRMessageAnnotation.h"

#import "UIView+Origami.h"
#import "NSDate+Additions.h"
#import "MKMapView+ZoomLevel.h"

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

static const CGFloat kDRMapHeight = 200.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tableview
    self.tableView.backgroundColor = [UIColor DRLightBackgroundColor];
    
    // tableview header
    self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kDRMapHeight)] autorelease];
//    self.mapView.delegate = self;
//    self.mapView.scrollEnabled = NO;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (( toInterfaceOrientation == UIInterfaceOrientationPortrait ) || ( toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ))
    {
        self.view = self.tableView;
    }
    else
    {
        self.view = self.mapView;
    }
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

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]] == YES)
    {
        return nil;  //return nil to use default blue dot view
    }
    else if ( [annotation isKindOfClass:[DRMessageAnnotation class]] == NO )
    {
        NSLog(@"unrecognized annotation. Class = %@", [annotation class]);
        return nil;
    }
    
    static NSString *AnnotationViewID = @"DRMessageAnnotationID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:AnnotationViewID] autorelease];
        annotationView.canShowCallout = YES;
        UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = calloutButton;
        annotationView.pinColor = MKPinAnnotationColorRed;
    }    
    annotationView.annotation = annotation;
    
    return annotationView;
}   

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%s called", __FUNCTION__);
}

#pragma mark - 
#pragma mark Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // set up some vars to keep track of the zoom region.
    /// @todo This is hacky. Instead, find the regions by doing top left/bottom right coords
    __block CLLocationCoordinate2D firstCord;
    
    // find all geo points in the messages and add them as annotations to the map
    NSMutableArray *newAnnotations = [[NSMutableArray alloc] init];

    [self.objects enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop)
     {
         NSAssert([obj isKindOfClass:[PFObject class]] == YES, @"Invalid class");
         PFGeoPoint *geoPoint = [obj objectForKey:@"location"];
         if ( geoPoint != nil )
         {
             if ( idx == 0 )
             {
                 firstCord = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
             }
             DRMessageAnnotation *annotation = [[DRMessageAnnotation alloc] initWithMessage:obj];
             [newAnnotations addObject:annotation];
         }
     }];

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:newAnnotations];
    [newAnnotations release];
    
    [self.mapView setCenterCoordinate:firstCord zoomLevel:12 animated:YES];
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
