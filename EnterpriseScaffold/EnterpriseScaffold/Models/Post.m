//
//  Post.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "Post.h"
#import "ImagePost.h"

@implementation Post

@dynamic iD,descriptionText,body,videoURL,date, title, images, videoImageCoverURL;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"iD",
     @"descriptive_text" : @"descriptionText",
     @"body" : @"body",
     @"youtube_direct_link" : @"videoURL",
     @"date" : @"date",
     @"title" : @"title",
     @"youtube_cover_image_url" : @"videoImageCoverURL"
     }];
    
    mapping.identificationAttributes = @[@"iD"];
    
     [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"all_images" toKeyPath:@"images" withMapping:[ImagePost mapping]]];
    
    return mapping;
}

+ (RKRoute*)route
{
    return [RKRoute routeWithName:@"post" pathPattern:@"post" method:RKRequestMethodGET];
}

#pragma mark - Fetch

+ (NSArray*)getAllOrderByDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSError *error;
    return [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

#pragma mark - Core Data Sync

+ (void)synchronizePosts:(NSArray*)postByServer
{
    NSError *error;
    NSArray *allPosts = [Post getAllOrderByDate];
    
    if (allPosts.count != postByServer.count && postByServer.count != 0) {
        for (Post *post in allPosts) {
            if ([Post array:postByServer containPost:post] ==  NO) {
                [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:post];
            }
        }
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
    }
    
    if (postByServer.count == 0) {
        for (Post *post in allPosts) {
            [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:post];
        }
    }
}

+ (BOOL)array:(NSArray*)posts containPost:(Post*)post
{
    for (Post *myPost in posts) {
        if ([myPost.iD isEqualToString:post.iD]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Override

- (void)setDate:(NSDate *)date
{
    NSDate* sourceDate = date;
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSDate* destinationDate = [date dateByAddingTimeInterval:-destinationGMTOffset];
    
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:destinationDate forKey:@"date"];
    [self didChangeValueForKey:@"date"];
}

@end
