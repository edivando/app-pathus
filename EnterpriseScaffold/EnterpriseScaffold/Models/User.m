//
//  User.m
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "User.h"
#import <RestKit/RestKit.h>
#import "EnterpriseConfig.h"
#import "FXKeychain.h"
#import "Exam.h"

#import "ExamClient.h"
#import "UserClient.h"

#import "NSString+Utility.h"

#import "NSDictionary+Utility.h"
#import "NSDate+Utility.h"

@implementation User

@dynamic name,email,cpf,telephone,password,token,identifier,userTypeEnum,tokenDate,celphone,petName, motherName, birthdate;

#pragma mark - Singleton

static User *_sharedUser = nil;
static dispatch_once_t onceToken = 0;

+ (User*)sharedUser
{
    dispatch_once(&onceToken, ^{
        
        NSError *error;
        NSFetchRequest *fetchRequestUser = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityUser = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
        [fetchRequestUser setEntity:entityUser];
        
        _sharedUser = [[[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequestUser error:&error] lastObject];
    });
    
    return _sharedUser;
}

+ (void)setSharedInstance:(User*)instance
{
    onceToken = 0;
    _sharedUser = instance;
}

+ (void)resetSharedInstance
{
    onceToken = 0;
    _sharedUser = nil;
}

+ (BOOL)isUserLogged
{
    NSFetchRequest *userRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSError *error;
    NSArray *users = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:userRequest error:&error];
    
    return (users.count > 0);
}

#pragma mark - Core Data

+ (User*)createIntityDBWithkData:(NSDictionary*)data token:(NSString*)token
{
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
    newUser.identifier = [[data objectForKey:@"id"] stringValue];
    [User setuserIdentifier:newUser.identifier];
    
    newUser.name = [data objectForKey:@"name"];
    newUser.telephone = [data objectForKey:@"telephone"];
    newUser.celphone = [data objectForKey:@"cellphone"];

    newUser.userTypeEnum = [User userTypeFromString:[data objectForKey:@"api_role"]];
    
    newUser.token = [data objectForKey:@"authentication_token"];
    //newUser.tokenDate = [User dateFromString:[data objectForKey:@"authentication_date"]]; // TODO: Qual é o formato dessa data?
    
    // May be null
    newUser.email = [data objectForKey:@"email"];
    newUser.cpf = [data objectForKey:@"email"];
    
    newUser.birthdate = [[data objectForKey:@"birth_date"] toBRDate];
    newUser.motherName = [data safeObjectForKey:@"mother_name"];

    [User setUserCredentials:@{@"authentication_token" : newUser.token , @"login" : newUser.email }];
    
    return newUser;
}

- (User*)updateUserWithResponse:(NSDictionary*)response
{
    User *user = [self mapping:response];
    
    NSError *error;
    [user.managedObjectContext save:&error];
    [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext save:&error];
    
    return user;
}

+ (void)removeAllFromEntity:(NSString*)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *itens = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *item in itens) {
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:item];
    }
    NSError *saveError = nil;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&saveError];
}


#pragma mark - Transforms

+ (NSDictionary*)transformUserToDictionary:(User*)thisUser
{
    return
    @{
              @"email" : thisUser.email,
              @"name" : thisUser.name,
              @"password" : thisUser.password,
              @"cpf" : thisUser.cpf,
              @"name" : thisUser.name,
              @"telephone" : thisUser.telephone,
              @"cellphone" :  thisUser.telephone,
              @"mother_name" :  thisUser.motherName,
              @"birth_date" :  [thisUser.birthdate formatToBRStr],
              @"api_role" : @"patient",
              @"device_id" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
              @"iphone_notification_token" : ([User pushToken]) ? : @"123123123",
              @"enterprise_id" :  [[EnterpriseConfig sharedInstance] iD],
      };
}

- (User*)mapping:(NSDictionary*)data
{
    self.name = [data objectForKey:@"name"];
    self.telephone = [data objectForKey:@"telephone"];
    self.celphone = [data objectForKey:@"celphone"];
    
    self.token = [data objectForKey:@"authentication_token"];
    //newUser.tokenDate = [User dateFromString:[data objectForKey:@"authentication_date"]]; // TODO: Qual é o formato dessa data?
    
    // May be null
    self.email = [data objectForKey:@"email"];
    self.cpf = [data objectForKey:@"email"];
    
    self.birthdate = [[data objectForKey:@"birth_date"] toBRDate];
    self.motherName = [data objectForKey:@"mother_name"];
    
    [User setUserCredentials:@{@"authentication_token" : self.token , @"login" : self.email }];
    
    return self;
}

+ (NSNumber*)userTypeFromString:(NSString*)userTypeStr
{
    if ([userTypeStr isEqualToString:@"patient"]) {
        return [NSNumber numberWithInt:UserTypePatient];
    }
    return [NSNumber numberWithInt:UserTypeDoctor];
}

+ (NSDate*)dateFromString:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ-HH:mm"];
    return [formatter dateFromString:dateStr];
}

#pragma mark - Preferences

+ (void)setShowExamsVC:(BOOL)showExamsVC
{
    [[NSUserDefaults standardUserDefaults] setBool:showExamsVC forKey:@"showExamsVC"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowExamsVC
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"showExamsVC"];
}

+ (void)setPushToken:(NSString*)token
{
    [FXKeychain defaultKeychain][@"pushToken"] = token;
}

+ (NSString*)pushToken
{
    return [FXKeychain defaultKeychain][@"pushToken"];
}

+ (void)setuserIdentifier:(NSString*)identifier
{
    [FXKeychain defaultKeychain][@"userIdentifier"] = identifier;
}

+ (NSString*)userIdentifier
{
    return [FXKeychain defaultKeychain][@"userIdentifier"];
}

+ (void)insertCredentialsOnHTTPClient:(AFHTTPClient*)httpClient
{
    NSDictionary *credentials = [User userCredentials];
    
    [httpClient setDefaultHeader:@"Authentication-Token" value:[credentials objectForKey:@"authentication_token"]];
    [httpClient setDefaultHeader:@"Login" value:[credentials objectForKey:@"login"]];
    [httpClient setDefaultHeader:@"Enterprise-id" value:ENTERPRISE_IDENTIFIER];
    [httpClient setDefaultHeader:@"Device-id" value:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
}

+ (void)setUserCredentials:(NSDictionary*)credentials
{
    [FXKeychain defaultKeychain][@"credentials"] = credentials;
}

+ (NSDictionary*)userCredentials
{
    return [FXKeychain defaultKeychain][@"credentials"];
}

#pragma mark - Override Get/Set

- (void)setUserType:(UserType)userType
{
    self.userTypeEnum = [NSNumber numberWithInt:userType];
}

- (UserType)userType
{
    return (UserType)[self.userTypeEnum intValue];
}

#pragma mark - Aux

+ (void)logout
{    
    // Reset Credentials
    [User setUserCredentials:nil];
    
    // Remove all Exams Files
    NSArray *allExams= [Exam getAllOrderByDate];
    for (Exam *exam in allExams) {
        if ([exam isPersisted]) {
            [exam removePDFFile];
        }
    }
    
    // Reset NSUserDefaults
     NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Reset Keychain
    [self resetKeychain];
    
    // Reset CoreData
    [User resetSharedInstance];
    [User removeAllFromEntity:@"User"];
    [User removeAllFromEntity:@"Exam"];
    
    NSError *error;
    [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext save:&error];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+ (void)resetKeychain
{
    //[User setPushToken:nil];
    [User setuserIdentifier:nil];
    [User setUserCredentials:nil];
}


@end
