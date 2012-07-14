//
//  DRItemCreateViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@class DRItemCreateViewController;
@protocol DRItemCreateViewControllerDelegate <NSObject>
@required
- (void)DRItemCreateViewController:(DRItemCreateViewController *)controller didCreateItem:(id)item;
@end

///////////////////////////////////////////////////////////////

@interface DRItemCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
@private
    id <DRItemCreateViewControllerDelegate> _delegate;
    PFObject *_parentObject;
    
@private
    UITextField *_titleTextField;
    UITextView *_descriptionTextView;
}

@property (nonatomic, retain, readwrite) PFObject *parentObject;
@property (nonatomic, assign, readwrite) id<DRItemCreateViewControllerDelegate> delegate;
@property (nonatomic, readonly) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, readonly) IBOutlet UITextField *titleTextField;

@end
