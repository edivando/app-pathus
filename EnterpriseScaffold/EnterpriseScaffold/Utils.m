//
//  Utils.m
//  Pathus
//
//  Created by Torquato on 25/08/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "Utils.h"

#import "DesignConfig.h"

@implementation Utils

+ (void)applyBorder:(UIButton*)button
{
    CGColorRef borderColor = PURPLE_COLOR.CGColor;
    
    button.layer.borderColor = borderColor;
    
    CGFloat borderWidth = 1.0;
    button.layer.borderWidth = borderWidth;
}

@end
