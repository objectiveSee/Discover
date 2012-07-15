//
//  DRCustomTableViewCell.m
//  Discover
//
//  Created by Sean Conrad on 7/14/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRCustomTableViewCell.h"

@implementation DRCustomTableViewCell
@synthesize userNameAndLocationLabel;
@synthesize timeLabel;
@synthesize messageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // various cell setup things
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[self messageLabel] setNumberOfLines:0];
    }
    
    return self;
}

- (void)dealloc {
    [userNameAndLocationLabel release];
    [timeLabel release];
    [messageLabel release];
    [super dealloc];
}

+ (CGFloat)preferredHeightForObject:(PFObject *)object width:(CGFloat)width
{
    NSString *text = [object objectForKey:@"text"];
    NSParameterAssert(text);
    
    //    BOOL hasRightColumnObject = NO;
    //    if ( [object objectForKey:@"location"] != nil )
    //    {
    //        hasRightColumnObject = YES;
    //    }
    //    if ( hasRightColumnObject == YES )
    //    {
    //        width -= 50;
    //    }
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, 10000)];
    return 20 + size.height;
}

@end
