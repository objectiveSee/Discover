//
//  DRUtility.h
//  Discover
//
//  Created by Danny Ricciotti on 7/29/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRUtility : NSObject <NSURLConnectionDelegate>
{
    NSMutableDictionary *_operations;
}

+ (id)sharedUtility;

- (void)syncCurrentUserFacebook;

@end
