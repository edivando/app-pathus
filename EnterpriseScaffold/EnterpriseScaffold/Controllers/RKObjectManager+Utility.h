//
//  RKObjectManager+Utility.h
//  PetProject
//
//  Created by Lucas Torquato on 2/22/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "RKObjectManager.h"

@interface RKObjectManager (Utility)

- (void)postParams:(NSDictionary*)params withPath:(NSString*)path onCompletion:(void (^)(NSDictionary *response))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

- (void)requestWithMethod:(NSString*)method params:(NSDictionary*)params path:(NSString*)path andHeader:(BOOL)isHeader onCompletion:(void (^)(NSDictionary *response))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

@end
