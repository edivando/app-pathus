//
//  EnterpriseConfig.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 04/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


///*** ***//

#define ES_HASH_KEY @"Exam-Secure"
#define ENTERPRISE_IDENTIFIER   @"1"
#define ENTERPRISE_API_URL      @"http://45.55.39.180/api/v1/"

///*** ***//

#import <Foundation/Foundation.h>

@interface EnterpriseConfig : NSObject

@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *apiURL;

+ (id) sharedInstance;

@end
