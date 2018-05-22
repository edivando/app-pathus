//
//  ExamClient.h
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class Exam;

@interface ExamClient : RKObjectManager

// Instance
+ (id)sharedInstance;
+ (void)resetSharedInstance;

// Request
- (void)allWithUserID:(NSString*)userID onSuccess:(void (^)(NSArray *))successBlock onError:(void (^)(NSError *))errorBlock;
- (void)downloadPDFExam:(Exam*)exam onSuccess:(void (^)(id ))successBlock onError:(void (^)(NSError *))errorBlock;
- (void)renewTokenWithCredentials:(NSDictionary*)credentials onSuccess:(void (^)(NSString *))successBlock onError:(void (^)(NSError *))errorBlock;

@end
