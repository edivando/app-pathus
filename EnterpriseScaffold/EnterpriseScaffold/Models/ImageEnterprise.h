//
//  ImageEnterprise.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@class Enterprise;

@interface ImageEnterprise : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * enterpriseID;

@property (nonatomic, retain) Enterprise * enterprise;

+ (RKObjectMapping*)mapping;

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock;
+ (void)insertAndSaveNewImageEnterprise:(UIImage*)image toEnterprise:(Enterprise*)enterprise inContext:(NSManagedObjectContext*)context;

@end
