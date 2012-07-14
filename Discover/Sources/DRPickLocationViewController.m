//
//  DRPickLocationViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRPickLocationViewController.h"

@interface DRPickLocationViewController ()
@property (nonatomic, retain, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;
- (void)_longPressGestureObserved:(UILongPressGestureRecognizer *)gestureRecognizer;
@property (nonatomic, retain, readwrite) MKPointAnnotation *mapPin;
- (void)_rightBarButtonItemWasPressed:(id)sender;
@end

@implementation DRPickLocationViewController
@synthesize mapView = _mapView;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize mapPin = _mapPin;
@synthesize itemDictionary = _itemDictionary;

#pragma mark -
#pragma mark Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pick location";
        self.longPressGestureRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressGestureObserved:)] autorelease];
    }
    return self;
}


#pragma mark -
#pragma mark UIViewController

- (void)dealloc
{
    self.itemDictionary = nil;
    self.mapPin = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;    

    [self.mapView addGestureRecognizer:self.longPressGestureRecognizer];
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
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    
    // @todo this will re-center map when used moves. not desired. only move once.
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"%s called", __FUNCTION__);
}

#pragma mark -
#pragma mark Private

- (void)_rightBarButtonItemWasPressed:(id)sender
{
    
    NSParameterAssert(self.itemDictionary);
    NSParameterAssert(self.mapPin);
    
    NSString *title = [self.itemDictionary objectForKey:@"title"];
    NSString *description = [self.itemDictionary objectForKey:@"description"];
    NSParameterAssert(title);
    NSParameterAssert(description);
    
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    self.navigationItem.titleView = indicator;
    [indicator startAnimating];

    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.mapPin.coordinate.latitude longitude:self.mapPin.coordinate.longitude];
    
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    [newItem setObject:[PFUser currentUser] forKey:@"creator"];
    [newItem setObject:geoPoint forKey:@"location"];
    [newItem setObject:title forKey:@"title"];
    
    PFObject *firstMessage = [PFObject objectWithClassName:@"Message"];
    [firstMessage setObject:[PFUser currentUser] forKey:@"creator"];
    [firstMessage setObject:geoPoint forKey:@"location"];
    [firstMessage setObject:description forKey:@"text"];
    [firstMessage setObject:newItem forKey:@"parent"];
    
    [firstMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         self.navigationItem.titleView = nil;
     }];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)_longPressGestureObserved:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    // remove previous pin
    [self.mapView removeAnnotation:self.mapPin];

    // add new pin
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    self.mapPin = [[[MKPointAnnotation alloc] init] autorelease];
    self.mapPin.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:self.mapPin];
    
    if ( self.navigationItem.rightBarButtonItem == nil )
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Create!" style:UIBarButtonItemStyleBordered target:self action:@selector(_rightBarButtonItemWasPressed:)] autorelease];
    }
}

@end
