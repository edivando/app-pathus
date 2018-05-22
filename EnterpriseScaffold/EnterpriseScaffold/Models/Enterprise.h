//
//  Enterprise.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@class ImageEnterprise;

@interface Enterprise : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, retain) NSString * firstDescription;
@property (nonatomic, retain) NSString * secondDescription;

@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * cellphone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * businessHours;
@property (nonatomic, retain) NSString * paymentMethods;
@property (nonatomic, retain) NSString * specialty;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * email;

@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSString * videoImageCoverURL;

@property (nonatomic, retain) NSSet * images;
@property (nonatomic, retain) NSSet * stores;

// Fetch
+ (Enterprise*)instance;

- (NSString*)fullDescription;

#pragma mark - Core Data Sync

+ (void)synchronizeImages:(NSArray*)imagesByServer;
+ (BOOL)array:(NSArray*)images containImageEnterprise:(ImageEnterprise*)imageEnterprise;

@end

@interface Enterprise (CoreDataGeneratedAccessors)

- (void)addImagesObject:(ImageEnterprise *)value;
- (void)removeImagesObject:(ImageEnterprise *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
