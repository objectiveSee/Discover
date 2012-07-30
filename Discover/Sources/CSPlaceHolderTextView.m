//
//  CSPlaceHolderTextView.m
//  CouchSurfing
//
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "CSPlaceHolderTextView.h"

@interface CSPlaceHolderTextView ()
- (void)_initialize;
- (void)_updateShouldShowPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@property (nonatomic, readonly) UILabel *placeholderLabel;
@end

@implementation CSPlaceHolderTextView

#pragma mark - Accessors

@synthesize placeholderLabel = _placeholderLabel;

- (void)setText:(NSString *)string {
	[super setText:string];
	[self _updateShouldShowPlaceholder];
}


- (void)setPlaceholder:(NSString *)string
{
    CGSize boundsSize = self.bounds.size;

    [self.placeholderLabel setText:string];
    self.placeholderLabel.frame = UIEdgeInsetsInsetRect(CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height), UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f));
    [self.placeholderLabel sizeToFit];

	[self _updateShouldShowPlaceholder];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];

    [_placeholderLabel release];
	[super dealloc];
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}

#pragma mark - Private

- (void)_initialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];

    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
    _placeholderLabel.numberOfLines = 0;
    [_placeholderLabel setTextColor:[UIColor lightGrayColor]];
    _placeholderLabel.userInteractionEnabled = NO;
    [self addSubview:_placeholderLabel];
}

- (void)_updateShouldShowPlaceholder {
    BOOL shouldHidePlaceholder = ([self.text length] > 0);

    if ( shouldHidePlaceholder != self.placeholderLabel.isHidden )
    {
        if ( shouldHidePlaceholder == NO )
        {
            // Update font if the font of the textview was changed programatically. 
            /// @note This should be done by overriding the setFont method instead
            [self.placeholderLabel setFont:self.font];
        }
        [self.placeholderLabel setHidden:shouldHidePlaceholder];
    }
}

- (void)_textChanged:(NSNotification *)notificaiton {
	[self _updateShouldShowPlaceholder];	
}

@end
