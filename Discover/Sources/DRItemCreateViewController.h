//
//  DRItemCreateViewController.h
//  Discover
//
//  Created by Danny Ricciotti on 6/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRItemCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    
@private
    UITextField *_titleTextField;
    UITextView *_descriptionTextView;
}

@property (nonatomic, readonly) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, readonly) IBOutlet UITextField *titleTextField;

@end
