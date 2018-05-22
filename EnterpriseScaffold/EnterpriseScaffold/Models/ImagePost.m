//
//  ImageProduct.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ImagePost.h"
#import "Post.h"

@implementation ImagePost

@dynamic image, post, postID, imageURL;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"ImagePost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
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
        if (![self.imageURL isEqualToString:@""]) {
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURL]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                self.image = image;
                [ImagePost contextDidSave:nil];
                
                successBlock(image, YES);
            } failure:nil];
        }
    }
}

#pragma mark - Core Data

+ (void)insertAndSaveNewImagePost:(UIImage*)image toPost:(Post*)post inContext:(NSManagedObjectContext*)context
{
    ImagePost *imagePost = [NSEntityDescription insertNewObjectForEntityForName:@"ImagePost" inManagedObjectContext:context];
    [imagePost setValue:image forKey:@"image"];
    [imagePost setValue:post.iD forKey:@"postID"];
    
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

/*
 + (void)synchronizeImagesWithProducts
 {
 NSFetchRequest *requestEvent = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
 [requestEvent setPredicate:[NSPredicate predicateWithFormat:@"imageLandscape == nil"]];
 
 NSError *error = nil;
 NSArray *eventWithoutImage = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:requestEvent error:&error];
 
 NSFetchRequest *requestImage = [[NSFetchRequest alloc] initWithEntityName:@"EventImageLandscape"];
 [requestImage setPredicate:[NSPredicate predicateWithFormat:@"event == nil"]];
 
 NSArray *imageWithoutEvent = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:requestImage error:&error];
 
 
 for (Event *event in eventWithoutImage) {
 
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id like %@", event.iD];
 EventImageLandscape *image = [imageWithoutEvent filteredArrayUsingPredicate:predicate].lastObject;
 
 if (image) {
 [event setImageLandscape:image];
 [image setEvent:event];
 
 [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
 }
 }
 }
 */

@end