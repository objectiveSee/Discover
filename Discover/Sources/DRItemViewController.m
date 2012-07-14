//
//  DRItemViewController.m
//  Discover
//
//  Created by Danny Ricciotti on 6/22/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemViewController.h"

@interface DRItemViewController ()
//- (void)_setStateIsLoading:(BOOL)isLoading;
@end

@implementation DRItemViewController
@synthesize item = _item;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = @"Message";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//}

#pragma mark - 
#pragma mark Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    NSLog(@"%s called", __FUNCTION__);
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    NSLog(@"%s called", __FUNCTION__);
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    NSParameterAssert(self.item);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query includeKey:@"creator"];
    
    [query whereKey:@"parent" equalTo:self.item];
    //    [query whereKey:@"location" nearGeoPoint:userGeoPoint];
    [query orderByDescending:@"updatedAt"];
    
    NSLog(@"Query = %@. Parent = %@", query, self.item);
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"text"];
//    cell.detailTextLabel.text = [message0 objectForKey:@"message"];
    
    //    PFFile *thumbnail = [object objectForKey:@"thumbnail"];
    //    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //    cell.imageView.file = thumbnail;
    return cell;
}


#pragma mark -
#pragma mark Private
/**
- (void)_setStateIsLoading:(BOOL)isLoading
{
    self.tableView.hidden = isLoading;
    
    if ( isLoading == YES )
    {
        UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        self.navigationItem.titleView = indicator;
        [indicator startAnimating];
    }
    else 
    {
        self.navigationItem.titleView = nil;
    }
}
 */

@end
