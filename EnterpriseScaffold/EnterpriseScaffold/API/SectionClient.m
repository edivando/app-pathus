//
//  SectionClient.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 04/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "SectionClient.h"
#import "EnterpriseConfig.h"
#import "Section.h"

@implementation SectionClient

#pragma mark - Restkit Config

+ (id)sharedInstance
{
    static SectionClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]];
        __sharedInstance = [SectionClient managerWithBaseURL:baseURL];
        __sharedInstance.requestSerializationMIMEType = RKMIMETypeJSON;
        [__sharedInstance.router.routeSet addRoute:[Section route]];
        [__sharedInstance addResponseDescriptors];
        [__sharedInstance setManagedObjectStore:[RKManagedObjectStore defaultStore]];
    });
    return __sharedInstance;
}

- (void)addResponseDescriptors
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Section mapping]
                                                                                            method:RKRequestMethodGET
                                                                                            pathPattern:nil
                                                                                            keyPath:nil
                                                                                            statusCodes:statusCodeSet];
    [self addResponseDescriptor:responseDescriptor];
}

#pragma mark - Requests

- (void)allWithEnterpriseID:(NSString*)enterpriseID onSuccess:(void (^)(NSArray *))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"enterprises/%@/menus",enterpriseID];
    
    [self getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        successBlock(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure");
        errorBlock(error);
    }];
}

@end
