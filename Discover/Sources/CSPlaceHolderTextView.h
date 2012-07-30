//
//  CSPlaceHolderTextView.h
//  CouchSurfing
//
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

/**
 @class CSPlaceHolderTextView
 @brief UITextView subclass that adds placeholder support like UITextField has.
 */
@interface CSPlaceHolderTextView : UITextView 
{
    UILabel *_placeholderLabel;
}

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
- (void)setPlaceholder:(NSString *)placeholder;

@end
