//
//  Section.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 29/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "Section.h"
#import "Product.h"
#import "SectionClient.h"


@implementation Section

@dynamic iD, descriptionText, name, priority, products, sections, belongs_section, imageURL, imageData;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Section" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"iD",
     @"name" : @"name",
     @"priority" : @"priority",
     @"image_url" : @"imageURL"
     }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    // Resolve: restkit core data nested
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        return mapping;
    }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sub_sections" toKeyPath:@"sections" withMapping:dynamicMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products" toKeyPath:@"products" withMapping:[Product mapping]]];
    
    return mapping;
}

+ (RKRoute*)route
{
    return [RKRoute routeWithName:@"section" pathPattern:@"section" method:RKRequestMethodGET];
}

#pragma mark - Fetch

+ (Section*)firstMasterSection
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(belongs_section == nil) AND (priority == %d)",0];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    Section *firstMasterSection = [[[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
    
    return firstMasterSection;
}

+ (Section*)secondMasterSection
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(belongs_section == nil) AND (priority == %d)",1];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    Section *secondMasterSection = [[[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
    
    return secondMasterSection;
}

#pragma mark - AUX

+ (NSArray*)allSectionsFromTree:(NSArray*)tree
{
    NSMutableArray *allSections = [[NSMutableArray alloc] init];;
    
    for (Section *section in tree) {
        
        NSLog(@"Name:%@  Sections:%lu Products:%lu",section.name, (unsigned long)section.sections.count, (unsigned long)section.products.count);
        [allSections addObject:section];
        if (section.sections.allObjects.count != 0) {
            [allSections addObjectsFromArray:[Section allSectionsFromTree:section.sections.allObjects]];
        }
    }
    
    return [[NSArray alloc] initWithArray:allSections];
}

#pragma mark - Core Data Sync

+ (void)synchronizeSections:(NSArray*)sectionByServer
{
    NSArray *sectionsCompleteByServer = [Section allSectionsFromTree:sectionByServer];
    
    NSError *error;
    NSFetchRequest *allSectionsRequest = [[NSFetchRequest alloc] initWithEntityName:@"Section"];
    NSArray *allSections = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:allSectionsRequest error:&error];
    
    if (allSections.count != sectionsCompleteByServer.count && sectionsCompleteByServer.count != 0) {
        for (Section *section in allSections) {
            if ([Section array:sectionsCompleteByServer containSection:section] ==  NO) {
                [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:section];
            }
        }
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
    }
}

+ (BOOL)array:(NSArray*)sections containSection:(Section*)section;
{
    for (Section *mySection in sections) {
        if ([mySection.iD isEqualToString:section.iD]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Get/Set Override

- (void)setImageURL:(NSString *)imageURL
{
    NSLog(@"%@ %@",imageURL, self.imageURL);
    
    if (![imageURL isEqualToString:self.imageURL]) {
        self.imageData = nil;
        [Section contextDidSave:nil];
        
        NSLog(@"%@ %@",imageURL, self.imageURL);
    }
    
    [self willChangeValueForKey:@"imageURL"];
    [self setPrimitiveValue:imageURL forKey:@"imageURL"];
    [self didChangeValueForKey:@"imageURL"];
    
    NSLog(@"%@ %@",imageURL, self.imageURL);
}

#pragma mark - Image Block

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock
{
    if (self.imageData) {
        successBlock([UIImage imageWithData:self.imageData], NO);
    }else{
        if (![self.imageURL isEqualToString:@""]) {
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURL]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                self.imageData = UIImagePNGRepresentation(image);
                [Section contextDidSave:nil];
                
                successBlock(image, YES);
            } failure:nil];
        }
    }
}

#pragma mark Merge Context

+ (void)contextDidSave:(NSNotification *)notification
{
    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    
    NSError *error;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
}


@end

