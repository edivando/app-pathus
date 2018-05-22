//
//  ExamClient.m
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "ExamClient.h"
#import "EnterpriseConfig.h"
#import "Exam.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperation+Utility.h"
#import "RKObjectManager+Utility.h"

@implementation ExamClient

static ExamClient *__sharedInstance;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:[[EnterpriseConfig sharedInstance] apiURL]];
        __sharedInstance = [ExamClient managerWithBaseURL:baseURL];
        __sharedInstance.requestSerializationMIMEType = RKMIMETypeJSON;
        [__sharedInstance.router.routeSet addRoute:[Exam route]];
        [__sharedInstance addResponseDescriptors];
        [__sharedInstance setManagedObjectStore:[RKManagedObjectStore defaultStore]];
        
    });
    return __sharedInstance;
}

+ (void)resetSharedInstance
{
    __sharedInstance = nil;
}

- (void)addResponseDescriptors
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Exam mapping]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodeSet];
    
    [self addResponseDescriptor:responseDescriptor];
}

#pragma mark - Requests

- (void)allWithUserID:(NSString*)userID onSuccess:(void (^)(NSArray *))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"api_users/%@/exams",userID];
    [User insertCredentialsOnHTTPClient:__sharedInstance.HTTPClient];
    
    [self getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        successBlock(mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
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
                
                errorBlock([NSError errorWithDomain:@"Token Renew. Try Again" code:555 userInfo:nil]);
                
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }else{        
            NSLog(@"Failure");
            errorBlock(error);
        }
        
    }];
}

- (void)downloadPDFExam:(Exam*)exam onSuccess:(void (^)(id ))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:exam.fileURL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *pdfName = [NSString stringWithFormat:@"%@.pdf",exam.name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:pdfName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);                
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
    }];
    
    __block float progress = 0.0;
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progress = (float)totalBytesRead / totalBytesExpectedToRead;
        [SVProgressHUD showProgress:progress status:@"Carregando..." maskType:SVProgressHUDMaskTypeClear];
        NSLog(@"Download = %f", progress);
    }];
    
    [operation start];
}

- (void)renewTokenWithCredentials:(NSDictionary*)credentials onSuccess:(void (^)(NSString *))successBlock onError:(void (^)(NSError *))errorBlock
{
    NSMutableDictionary *params = [credentials mutableCopy];
    params[@"enterprise_id"] = ENTERPRISE_IDENTIFIER;
  
    [self postParams:params withPath:@"authentication/renew_auth_token" onCompletion:^(NSDictionary *response) {
        
        successBlock([response objectForKey:@"authentication_token"]);
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
    
}



@end
