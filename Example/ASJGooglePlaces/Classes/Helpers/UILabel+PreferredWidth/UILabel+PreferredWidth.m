//
//  UILabel+PreferredWidth.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "UILabel+PreferredWidth.h"

@implementation UILabel (PreferredWidth)

- (CGFloat)preferredMaxWidthWithPadding:(CGFloat)padding
{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return screenWidth - self.frame.origin.y - padding;
}

@end
