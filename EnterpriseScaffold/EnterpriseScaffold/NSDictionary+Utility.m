//
//  NSDictionary+Utility.m
//  Pathus
//
//  Created by Torquato on 08/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

- (id)safeObjectForKey:(NSString*)key
{
    id value = [self objectForKey:key];
    return (value == NULL || value) ? @"" : value;
}

@end
