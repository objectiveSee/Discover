//
//  DRCustomTableViewCell.h
//  Discover
//
//  Created by Sean Conrad on 7/14/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRCustomTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *userNameAndLocationLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

+ (CGFloat)preferredHeightForObject:(PFObject *)object width:(CGFloat)width;

@end
