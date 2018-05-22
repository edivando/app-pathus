//
//  Product.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 28/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@class Section, ImageProduct;

@interface Product : NSManagedObject <RestKitProtocol>

// Attributes
@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * referency;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * mainImageURLStr;

// Relationships
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet * images;

// Core Data Context
+ (void)contextDidSave:(NSNotification *)notification;

- (ImageProduct*)mainImageProduct;
// Image Block
//- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock;

// Core Data Sync
+ (void)synchronizeProducts:(NSArray*)sectionByServer;
+ (BOOL)array:(NSArray*)products containProduct:(Product*)product;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addImagesObject:(ImageProduct *)value;
- (void)removeImagesObject:(ImageProduct *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end

