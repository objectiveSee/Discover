//
//  NSDate+Additions.m
//  Discover
//
//  Created by Danny Ricciotti on 7/14/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)recentDateAndTimeString
{
    static const NSTimeInterval kSecondsInADay = 86400;
    static const NSTimeInterval kSecondsInAHour = 3600;
    static const NSTimeInterval kSecondsInAMinute = 60;
    NSTimeInterval secondsSinceDate = (-[self timeIntervalSinceNow]);
    if ( secondsSinceDate >= kSecondsInADay )
    {
        NSInteger days = secondsSinceDate / kSecondsInADay;
        return [NSString stringWithFormat:@"%dd", days];
    }
    if ( secondsSinceDate >= kSecondsInAHour )
    {
        NSInteger hours = secondsSinceDate / kSecondsInAHour;
        return [NSString stringWithFormat:@"%dh", hours];
    }
    else
    {
        NSInteger minutes = MAX(secondsSinceDate / kSecondsInAMinute, 0);
        return [NSString stringWithFormat:@"%dm", minutes];
    }
    return @"";
}

@end
