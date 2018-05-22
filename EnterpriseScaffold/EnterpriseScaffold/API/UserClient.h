//
//  UserClient.h
//  PetProject
//
//  Created by Lucas Torquato on 1/31/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class User;

@interface UserClient : RKObjectManager

// Instance
+ (id)sharedInstance;

// Sign Up
- (void)signUpWithUserData:(User*)userLocal onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

// Login
- (void)loginWithCredentials:(NSString*)email password:(NSString*)password onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

// Forget Password
- (void)forgetPasswordWithLogin:(NSString*)login onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

// Save Anonymous Token
- (void)saveAnonymousPushToken:(NSString*)pushToken onSuccess:(void (^)())successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;

// Renew Token
- (void)renewTokenWithCredentials:(NSDictionary*)credentials onSuccess:(void (^)(NSString *))successBlock onError:(void (^)(NSError *))errorBlock;

// Update User
- (void)updateUser:(NSDictionary*)userDic onSuccess:(void (^)(User *user))successBlock onError:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorBlock;


@end
