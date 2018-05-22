//
//  RKObjectManager+Utility.m
//  PetProject
//
//  Created by Lucas Torquato on 2/22/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "RKObjectManager+Utility.h"
#import "EnterpriseConfig.h"
#import "User.h"

@implementation RKObjectManager (Utility)

#pragma mark - Base Request Post

- (void)postParams:(NSDictionary*)params withPath:(NSString*)path onCompletion:(void (^)(NSDictionary *response))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            
            NSError *error;
            NSDictionary *dictionaryResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            successBlock(dictionaryResponse);
            
        }else{
            errorBlock(operation, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
    [operation start];
}

- (void)requestWithMethod:(NSString*)method params:(NSDictionary*)params path:(NSString*)path andHeader:(BOOL)isHeader onCompletion:(void (^)(NSDictionary *response))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    if (isHeader) {
        NSDictionary *credentials = [User userCredentials];
        [httpClient setDefaultHeader:@"Authentication-Token" value:[credentials objectForKey:@"authentication_token"]];
        [httpClient setDefaultHeader:@"Login" value:[credentials objectForKey:@"login"]];
        [httpClient setDefaultHeader:@"Enterprise-id" value:ENTERPRISE_IDENTIFIER];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:method path:path parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            
            NSError *error;
            NSDictionary *dictionaryResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            successBlock(dictionaryResponse);
            
        }else{
            errorBlock(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(nil, error);
    }];
    
    [operation start];

}

@end
