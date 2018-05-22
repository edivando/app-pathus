//
//  Product.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 28/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "Product.h"
#import "Section.h"
#import "ImageProduct.h"

@implementation Product

@dynamic iD, name, descriptionText, priority, price, section, referency,images, mainImageURLStr;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Product" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"iD",
     @"description" : @"descriptionText",
     @"referency" : @"referency",
     @"priority" : @"priority",
     @"price" : @"price",
     @"main_image_url" : @"mainImageURLStr"
     }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"all_images" toKeyPath:@"images" withMapping:[ImageProduct mapping]]];
    
    return mapping;
}

#pragma mark Merge Context

+ (void)contextDidSave:(NSNotification *)notification
{
    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    
    NSError *error;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
}

#pragma mark - Aux

+ (NSArray*)allProductsFromTree:(NSArray*)tree // Tree -> Array de Sections
{
    NSMutableArray *allProducts = [NSMutableArray new];
    NSArray *allSections = [Section allSectionsFromTree:tree];
    
    for (Section *section in allSections) {
        
        if (section.products.allObjects.count == 0) {
            [allProducts addObjectsFromArray:[self allProductsFromTree:section.sections.allObjects]];
        }else{
            [allProducts addObjectsFromArray:section.products.allObjects];
        }
    }
    
    return [NSArray arrayWithArray:allProducts];
}

- (ImageProduct*)mainImageProduct
{
    return [[self.images.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(originImageURL ==[c] %@) OR (imageURL ==[c] %@)", self.mainImageURLStr, self.mainImageURLStr]] firstObject];
}


#pragma mark - Core Data Sync

+ (void)synchronizeProducts:(NSArray*)sectionByServer
{
    NSArray *productsCompleteByServer = [Product allProductsFromTree:sectionByServer];
    
    NSError *error;
    NSFetchRequest *allProductsRequest = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    NSArray *allProducts = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:allProductsRequest error:&error];
    
    if (allProducts.count != productsCompleteByServer.count && productsCompleteByServer.count != 0) {
        for (Product *product in allProducts) {
            if ([Product array:productsCompleteByServer containProduct:product] ==  NO) {
                [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:product];
            }
        }
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
    }
}

+ (BOOL)array:(NSArray*)products containProduct:(Product*)product
{
    for (Product *myProduct in products) {
        if ([myProduct.iD isEqualToString:product.iD]) {
            return YES;
        }
    }
    return NO;
}


@end
