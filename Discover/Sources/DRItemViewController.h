//
//  DRItemViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemCreateViewController.h"

@interface DRItemViewController : PFQueryTableViewController <DRItemCreateViewControllerDelegate>
{
    PFObject *_item;
}

@property (nonatomic, retain, readwrite) PFObject *item;

@end
