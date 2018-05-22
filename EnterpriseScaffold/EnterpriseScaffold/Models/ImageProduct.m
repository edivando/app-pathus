//
//  ImageProduct.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/2/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ImageProduct.h"
#import "Product.h"

@implementation ImageProduct

@dynamic image, product, productID, imageURL, originImageURL;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"ImageProduct" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"url" : @"imageURL"
     }];
    
    mapping.identificationAttributes = @[@"imageURL"];
    
    return mapping;
}


#pragma mark - Image Block

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock
{
    if (self.image) {
        successBlock((UIImage*)self.image, NO);
    }else{
        if (![self.imageURL isEqualToString:@""] || ![self.originImageURL isEqualToString:@""]) {
            NSString *urlSTR = (self.imageURL) ? self.imageURL : self.originImageURL;
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlSTR]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                self.image = image;
                [ImageProduct contextDidSave:nil];
                
                successBlock(image, YES);
            } failure:nil];
        }
    }
}

#pragma mark - Core Data

+ (void)insertAndSaveNewImageProduct:(UIImage*)image toProduct:(Product*)product inContext:(NSManagedObjectContext*)context
{
    ImageProduct *imageProduct = [NSEntityDescription insertNewObjectForEntityForName:@"ImageProduct" inManagedObjectContext:context];
    [imageProduct setValue:image forKey:@"image"];
    [imageProduct setValue:product.iD forKey:@"productID"];
    
    NSError *error;
    [context save:&error];
    
}

+ (void)contextDidSave:(NSNotification *)notification
{
    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    
    NSError *error;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
}

@end
