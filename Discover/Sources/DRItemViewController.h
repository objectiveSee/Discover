//
//  DRItemViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    PFObject *_item;
    PFObject *_itemMessages;

    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    BOOL _dataIsReady;
    NSArray *_conversationArray;
}


@property (nonatomic, retain, readwrite) PFObject *item;

@property (nonatomic, readonly) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
