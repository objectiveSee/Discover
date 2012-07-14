//
//  DRItemTableViewCell.h
//  Discover
//
//  Created by Danny Ricciotti on 7/13/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

@interface DRItemTableViewCell : PFTableViewCell
{
    UILabel *_dateLabel;
}

@property (nonatomic, retain, readonly) UILabel *dateLabel;

+ (CGFloat)preferredHeightForObject:(PFObject *)object width:(CGFloat)width;

@end
