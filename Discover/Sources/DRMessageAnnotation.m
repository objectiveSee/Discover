//
//  DRMessageAnnotation.m
//  Discover
//
//  Created by Danny Ricciotti on 7/14/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRMessageAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface DRMessageAnnotation ()
@property ( nonatomic, retain, readwrite ) PFObject *message;
@property ( nonatomic, retain, readwrite ) PFGeoPoint *location;
@end

@implementation DRMessageAnnotation
@synthesize message = _message;
@synthesize location = _location;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithMessage:(PFObject *)message
{
    self = [super init];
    if ( self != nil )
    {
        NSParameterAssert(message);
        
        self.location = [message objectForKey:@"location"];
        NSParameterAssert(self.location);
        
        self.message = message;
    }
    return self;
}

- (void)dealloc
{
    self.location = nil;
    self.message = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude);
}

- (NSString *)title
{
    return [self.message objectForKey:@"text"];
}

//- (NSString *)subtitle
//{
//    return [self.message objectForKey:@"text"];    
//}

@end
