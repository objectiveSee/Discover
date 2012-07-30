//
//  DRUtility.m
//  Discover
//
//  Created by Danny Ricciotti on 7/29/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRUtility.h"

@interface DRUtility ()
@property (nonatomic, retain, readwrite) NSMutableDictionary *operations;
@end 

///////////////////////////////////////////////////////////////

@implementation DRUtility
@synthesize operations = _operations;

#pragma mark -
#pragma mark Life Cycle

- (id)init
{
    self = [super init];
    if ( self != nil )
    {
        self.operations = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.operations = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Public

+ (id)sharedUtility
{
    static DRUtility *utility = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        utility = [[DRUtility alloc] init];
    });
    return utility;
}

- (void)syncCurrentUserFacebook
{
//    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
//    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
//    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
    
    /// @todo OpenGraph stuff. see anypic's PFFacebookUtils.m
}

@end
