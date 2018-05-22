//
//  ImageEnterprise.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ImageEnterprise.h"
#import "Enterprise.h"

@implementation ImageEnterprise

@dynamic image, enterprise, enterpriseID, imageURL, iD;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"ImageEnterprise" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"iD",
     @"url" : @"imageURL"
     }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    return mapping;
}


#pragma mark - Image Block

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock
{
    if (self.image) {
        successBlock((UIImage*)self.image, NO);
    }else{
        if (![self.imageURL isEqualToString:@""]) {
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURL]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                self.image = image;
                [ImageEnterprise contextDidSave:nil];
                
                successBlock(image, YES);
            } failure:nil];
        }
    }
}

#pragma mark - Core Data

+ (void)insertAndSaveNewImageEnterprise:(UIImage*)image toEnterprise:(Enterprise*)enterprise inContext:(NSManagedObjectContext*)context
{
    ImageEnterprise *imageEnterprise = [NSEntityDescription insertNewObjectForEntityForName:@"ImageEnterprise" inManagedObjectContext:context];
    [imageEnterprise setValue:image forKey:@"image"];
    [imageEnterprise setValue:enterprise.iD forKey:@"enterpriseID"];
    
    NSError *error;
    [context save:&error];
    
}


+ (void)contextDidSave:(NSNotification *)notification
{
    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    
    NSError *error;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
    /*
     SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
     [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
     
     [self synchronizeImagesWithProducts];*/
}


@end
