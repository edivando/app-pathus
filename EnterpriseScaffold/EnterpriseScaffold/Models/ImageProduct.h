//
//  ImageProduct.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/2/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@class Product;

@interface ImageProduct : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * originImageURL; // Only in Cart
@property (nonatomic, retain) NSString * imageURL;

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * productID;

@property (nonatomic, retain) Product * product;

+ (RKObjectMapping*)mapping;

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock;
+ (void)insertAndSaveNewImageProduct:(UIImage*)image toProduct:(Product*)product inContext:(NSManagedObjectContext*)context;
//+ (void)contextDidSave:(NSNotification *)notification;
//+ (void)synchronizeImagesWithProducts;

@end
