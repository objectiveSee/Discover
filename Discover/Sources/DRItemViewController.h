//
//  DRItemViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRItemViewController : PFQueryTableViewController
{
    PFObject *_item;
}

@property (nonatomic, retain, readwrite) PFObject *item;

@end
