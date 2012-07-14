//
//  DRMessageAnnotation.h
//  Discover
//
//  Created by Danny Ricciotti on 7/14/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DRMessageAnnotation : NSObject <MKAnnotation>
{
    PFObject *_message;
    PFGeoPoint *_location;
}

@property ( nonatomic, retain, readonly ) PFObject *message;

- (id)initWithMessage:(PFObject *)message;

@end
