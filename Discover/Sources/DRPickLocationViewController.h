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
    MKMapView *_mapView;

    UILongPressGestureRecognizer *_longPressGestureRecognizer; 
    MKPointAnnotation *_mapPin;

    NSMutableDictionary *_itemDictionary;
}

@property (nonatomic, copy, readwrite) NSMutableDictionary *itemDictionary;
@property (nonatomic, readonly) IBOutlet MKMapView *mapView;

@end
