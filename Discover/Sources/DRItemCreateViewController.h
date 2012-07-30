//
//  DRItemCreateViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRPickLocationViewController.h"

@class CSPlaceHolderTextView;

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
    CSPlaceHolderTextView *_descriptionTextView;
    UIButton *_addLocationButton;

@private
    UIView *_keyboardAccessoryView;
    
    BOOL _locationRequired;
}

@property (nonatomic, retain, readonly) IBOutlet UIButton *addLocationButton;
@property (nonatomic, retain, readwrite) PFObject *parentObject;
@property (nonatomic, assign, readwrite) id<DRItemCreateViewControllerDelegate> delegate;
@property (nonatomic, readonly) IBOutlet CSPlaceHolderTextView *descriptionTextView;
@property (nonatomic, readonly) IBOutlet UIView *keyboardAccessoryView;
@property (nonatomic, assign, readwrite) BOOL locationRequired;
- (IBAction)addLocationButtonWasPressed:(id)sender;

@end
