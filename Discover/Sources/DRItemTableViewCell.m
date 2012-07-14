//
//  DRItemTableViewCell.m
//  Discover
//
//  Created by Danny Ricciotti on 7/13/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "DRItemTableViewCell.h"

@implementation DRItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
//        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    [self.textLabel setFrame:CGRectMake(0.0f, 0.0f, width, 20)];
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.frame = CGRectMake(0, 20, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

#pragma mark -
#pragma mark Public

+ (CGFloat)preferredHeightForObject:(PFObject *)object width:(CGFloat)width
{
    NSString *text = [object objectForKey:@"text"];
    NSParameterAssert(text);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(width, 10000)];
    NSLog(@"Size = %@ (width = %f) for String: %@", NSStringFromCGSize(size), width, text);
    return 20 + size.height;
}

@end
