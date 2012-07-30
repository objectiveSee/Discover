//
//  DRSignUpViewController.h
//  Discover
//
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRSignUpViewController : UIViewController
{
    UIButton *_fbButton;
}

- (IBAction)facebookButtonWasPressed:(id)sender;

@property (nonatomic, retain, readonly) IBOutlet UIButton *fbButton;

@end
