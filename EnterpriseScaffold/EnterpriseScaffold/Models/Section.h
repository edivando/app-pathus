//
//  Section.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 29/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "RestKitProtocol.h"

@class Product, Section;

@interface Section : NSManagedObject  <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSSet *products;
@property (nonatomic, retain) NSSet *sections;
@property (nonatomic, retain) Section *belongs_section;

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, strong) NSData * imageData;

// Fetch
+ (Section*)firstMasterSection;
+ (Section*)secondMasterSection;

// Core Data Context
+ (void)contextDidSave:(NSNotification *)notification;

// Image Block
- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock;

// Core Data Sync
+ (void)synchronizeSections:(NSArray*)sectionByServer;
+ (BOOL)array:(NSArray*)sections containSection:(Section*)section;

// Aux
+ (NSArray*)allSectionsFromTree:(NSArray*)tree;

@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

- (void)addSectionsObject:(Section *)value;
- (void)removeSectionsObject:(Section *)value;
- (void)addSections:(NSSet *)values;
- (void)removeSections:(NSSet *)values;

@end
