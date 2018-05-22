//
//  SectionClient.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 04/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol RestKitProtocol <NSObject>

@required
+ (RKObjectMapping*)mapping;
@optional
+ (RKRoute*)route;

@end
