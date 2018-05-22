//
//  User.h
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    UserTypePatient = 0,
    UserTypeDoctor = 1
} UserType;

@class AFHTTPClient;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * cpf;
@property (nonatomic, retain) NSString * celphone;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * petName;

@property (nonatomic, retain) NSDate * birthdate;
@property (nonatomic, retain) NSString * motherName;

@property (nonatomic, assign) UserType userType;     // Transient
@property (nonatomic, retain) NSNumber * userTypeEnum; // Persistent

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSDate   * tokenDate;

// Singleton
+ (User*)sharedUser;
+ (void)resetSharedInstance;

// Dic -> User DB
+ (User*)createIntityDBWithkData:(NSDictionary*)data token:(NSString*)token;

// User -> Dic
+ (NSDictionary*)transformUserToDictionary:(User*)thisUser;

// Credentials
+ (void)setPushToken:(NSString*)token;
+ (NSString*)pushToken;
+ (void)insertCredentialsOnHTTPClient:(AFHTTPClient*)httpClient;
+ (void)setUserCredentials:(NSDictionary*)credentials;
+ (NSDictionary*)userCredentials;
+ (void)setuserIdentifier:(NSString*)identifier;
+ (NSString*)userIdentifier;

// Aux
+ (BOOL)isUserLogged;
+ (void)logout;
+ (void)resetKeychain;

//
- (User*)updateUserWithResponse:(NSDictionary*)response;
+ (void)setShowExamsVC:(BOOL)showExamsVC;
+ (BOOL)isShowExamsVC;

@end
