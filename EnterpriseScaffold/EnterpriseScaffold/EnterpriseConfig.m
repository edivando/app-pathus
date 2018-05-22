//
//  EnterpriseConfig.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 04/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "EnterpriseConfig.h"

@implementation EnterpriseConfig

+ (id) sharedInstance
{
    static EnterpriseConfig *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[EnterpriseConfig alloc] init];
        [__sharedInstance setID:ENTERPRISE_IDENTIFIER];
        [__sharedInstance setApiURL:ENTERPRISE_API_URL];
    });
    
    return __sharedInstance;
}

@end
