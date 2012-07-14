//
//  DRItemCreateViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRPickLocationViewController.h"

///////////////////////////////////////////////////////////////

@class DRItemCreateViewController;
@protocol DRItemCreateViewControllerDelegate <NSObject>
@required
- (void)DRItemCreateViewController:(DRItemCreateViewController *)controller didCreateItem:(id)item;
@end

///////////////////////////////////////////////////////////////

@interface DRItemCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, DRPickLocationViewControllerDelegate>
{
@private
    id <DRItemCreateViewControllerDelegate> _delegate;
    PFObject *_parentObject;
    PFGeoPoint *_location;
    
@private
    UIView *_itemToolbarView;
    UITextField *_titleTextField;
    UITextView *_descriptionTextView;
    UIButton *_addLocationButton;
}

@property (nonatomic, retain, readonly) IBOutlet UIButton *addLocationButton;
@property (nonatomic, retain, readonly) IBOutlet UIView *itemToolbarView;
@property (nonatomic, retain, readwrite) PFObject *parentObject;
@property (nonatomic, assign, readwrite) id<DRItemCreateViewControllerDelegate> delegate;
@property (nonatomic, readonly) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, readonly) IBOutlet UITextField *titleTextField;

- (IBAction)addLocationButtonWasPressed:(id)sender;

@end
