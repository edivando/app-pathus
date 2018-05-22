//
//  EnterpriseCliente.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface EnterpriseClient : RKObjectManager

// Instance
+ (id)sharedInstance;

// Request
- (void)allWithEnterpriseID:(NSString*)enterpriseID onSuccess:(void (^)(NSArray *))successBlock onError:(void (^)(NSError *))errorBlock;

@end
