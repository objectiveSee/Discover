//
//  DRPickLocationViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import <MapKit/MapKit.h>

@class DRPickLocationViewController;

@protocol DRPickLocationViewControllerDelegate <NSObject>
@optional
- (void)DRPickLocationViewController:(DRPickLocationViewController *)controller didPickLocation:(id)location;
@end

@interface DRPickLocationViewController : UIViewController <MKMapViewDelegate>
{
    id <DRPickLocationViewControllerDelegate> delegate;
    MKMapView *_mapView;

    UILongPressGestureRecognizer *_longPressGestureRecognizer; 
    MKPointAnnotation *_mapPin;
}

@property (nonatomic, assign, readwrite) id <DRPickLocationViewControllerDelegate> delegate;
@property (nonatomic, readonly) IBOutlet MKMapView *mapView;

@end
