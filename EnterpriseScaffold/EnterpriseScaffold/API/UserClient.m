//
//  UserClient.m
//  PetProject
//
//  Created by Lucas Torquato on 1/31/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "UserClient.h"
#import "EnterpriseConfig.h"
#import "User.h"
#import "NSString+Utility.h"
#import "RKObjectManager+Utility.h"
#import "User.h"
#import "EnterpriseConfig.h"

#define SIGN_UP_WITH_SERVER_PATH @"api_users"
#define LOGIN_WITH_SERVER_PATH @"authentication"

@implementation UserClient

#pragma mark - Restkit Config

+ (id)sharedInstance
{
    static UserClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]];
        __sharedInstance = [UserClient managerWithBaseURL:baseURL];
        __sharedInstance.requestSerializationMIMEType = RKMIMETypeJSON;
    });
    return __sharedInstance;
}

#pragma mark - Requests

- (void)signUpWithUserData:(User*)userLocal onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    [self postParams:[User transformUserToDictionary:userLocal] withPath:SIGN_UP_WITH_SERVER_PATH onCompletion:^(NSDictionary *response) {        
        
        User *user = [User createIntityDBWithkData:response token:nil];
        
        NSError *error;
        [user.managedObjectContext save:&error];
        [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext  save:&error];
        
        successBlock(user);
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
}


- (void)loginWithCredentials:(NSString*)email password:(NSString*)password onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    NSString *pushToken = [User pushToken] ? [User pushToken] : @"";
    
    NSDictionary *params = @{@"login" : email,
                             @"password" : password,
                             @"iphone_notification_token": pushToken,
                             @"device_id" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             @"enterprise_id" : ENTERPRISE_IDENTIFIER};
    
    [self postParams:params withPath:LOGIN_WITH_SERVER_PATH onCompletion:^(NSDictionary *response) {
        
        User *user = [User createIntityDBWithkData:response token:nil];
        
        NSError *error;
        [user.managedObjectContext save:&error];
        [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext  save:&error];
        
        successBlock(nil);
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, nil);
    }];
}

- (void)forgetPasswordWithLogin:(NSString*)login onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    [self postParams:@{@"login" :  login, @"enterprise_id" : ENTERPRISE_IDENTIFIER} withPath:@"api_users/reset_password_request" onCompletion:^(NSDictionary *response) {
        successBlock(nil);
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(operation, nil);
    }];
}


- (void)saveAnonymousPushToken:(NSString*)pushToken onSuccess:(void (^)())successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"enterprises/%@/notification_users",ENTERPRISE_IDENTIFIER];
    
    [self requestWithMethod:@"POST" params:@{@"iphone_notification_token" : pushToken} path:path andHeader:NO onCompletion:^(NSDictionary *response) {
        successBlock();
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(operation, error);
    }];
}

- (void)updateUser:(NSDictionary*)userDic onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", SIGN_UP_WITH_SERVER_PATH, [User sharedUser].identifier];
    [self requestWithMethod:@"PUT" params:userDic path:path andHeader:YES onCompletion:^(NSDictionary *response) {
        
        User *user = [[User sharedUser] updateUserWithResponse:response];
        successBlock(user);
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *responseBody = [[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
        NSData *jsonData = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *responseDict = nil;
        if (jsonData != nil) {
            responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        }
        
        
        if ([responseDict[@"code"] integerValue] == 111) {
            
            [self renewTokenWithCredentials:[User userCredentials] onSuccess:^(NSString *newToken) {
                
                [User setUserCredentials:@{@"authentication_token" : newToken , @"login" : [[User userCredentials] objectForKey:@"login"] }];
                [User insertCredentialsOnHTTPClient:self.HTTPClient];
                
                errorBlock(operation, [NSError errorWithDomain:@"Token Renew. Try Again" code:555 userInfo:nil]);
                
            } onError:^(NSError *error) {
                errorBlock(operation ,error);
            }];
        }else{
            NSLog(@"Failure");
            errorBlock(operation, error);
        }
    }];
}


#pragma mark - Renew Token

- (void)renewTokenWithCredentials:(NSDictionary*)credentials onSuccess:(void (^)(NSString *))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSMutableDictionary *params = [credentials mutableCopy];
    params[@"enterprise_id"] = ENTERPRISE_IDENTIFIER;
    params[@"device_id"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [self requestWithMethod:@"POST" params:params path:@"authentication/renew_auth_token" andHeader:YES onCompletion:^(NSDictionary *response) {
        successBlock([response objectForKey:@"authentication_token"]);
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}


@end
