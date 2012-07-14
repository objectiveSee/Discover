//
//  UIColor+Additions.m
//  Discover
//
//  Created by Danny Ricciotti on 7/13/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)DRLightBackgroundColor
{
    static UIColor *lightBackgroundColor = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        lightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light-bk.png"]];
    });
    return [[lightBackgroundColor retain] autorelease];
}


@end
