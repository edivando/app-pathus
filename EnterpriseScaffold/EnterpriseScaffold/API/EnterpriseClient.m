//
//  EnterpriseCliente.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "EnterpriseClient.h"
#import "EnterpriseConfig.h"
#import "Enterprise.h"

@implementation EnterpriseClient

#pragma mark - Restkit Config

+ (id)sharedInstance
{
    static EnterpriseClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]];
        __sharedInstance = [EnterpriseClient managerWithBaseURL:baseURL];
        __sharedInstance.requestSerializationMIMEType = RKMIMETypeJSON;
        [__sharedInstance.router.routeSet addRoute:[Enterprise route]];
        [__sharedInstance addResponseDescriptors];
        [__sharedInstance setManagedObjectStore:[RKManagedObjectStore defaultStore]];
    });
    return __sharedInstance;
}

- (void)addResponseDescriptors
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Enterprise mapping]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodeSet];
    [self addResponseDescriptor:responseDescriptor];
}

#pragma mark - Requests

- (void)allWithEnterpriseID:(NSString*)enterpriseID onSuccess:(void (^)(NSArray *))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"enterprises/%@",enterpriseID];
    
    [self getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        successBlock(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        errorBlock(error);
    }];
}

@end
