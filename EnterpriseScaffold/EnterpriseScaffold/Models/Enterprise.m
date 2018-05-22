//
//  Enterprise.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "Enterprise.h"
#import "ImageEnterprise.h"
#import "Store.h"

@implementation Enterprise

@dynamic iD, name, firstDescription, secondDescription, website, telephone, cellphone, address, businessHours, paymentMethods, specialty, latitude, longitude, email, videoURL, videoImageCoverURL, images, stores;

#pragma mark - RestKit

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Enterprise" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"iD",
     @"name" : @"name",
     @"first_description" : @"firstDescription",
     @"second_description" : @"secondDescription",
     @"website" : @"website",
     @"telephone" : @"telephone",
     @"cellphone" : @"cellphone",
     @"address" : @"address",
     @"business_hours" : @"businessHours",
     @"payment_methods" : @"paymentMethods",
     @"specialty" : @"specialty",
     @"latitude" : @"latitude",
     @"longitude" : @"longitude",
     @"contact_mail" : @"email",
     @"media.youtube_video" : @"videoURL",
     @"media.youtube_cover_image_url" : @"videoImageCoverURL"
     }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"media.images" toKeyPath:@"images" withMapping:[ImageEnterprise mapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stores" toKeyPath:@"stores" withMapping:[Store mapping]]];
    
    return mapping;
}

+ (RKRoute*)route
{
    return [RKRoute routeWithName:@"enterprise" pathPattern:@"enterprise" method:RKRequestMethodGET];
}

#pragma mark - Fetch

+ (Enterprise*)instance
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Enterprise" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    return [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error].lastObject;
}

#pragma mark - Core Data Sync

+ (void)synchronizeImages:(NSArray*)imagesByServer
{
    NSError *error;
    NSFetchRequest *allImagesEnterpriseRequest = [[NSFetchRequest alloc] initWithEntityName:@"ImageEnterprise"];
    NSArray *allImagesEnterprise = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:allImagesEnterpriseRequest error:&error];


    if (allImagesEnterprise.count != imagesByServer.count && imagesByServer.count != 0) {
        for (ImageEnterprise *imageEnterprise in allImagesEnterprise) {
            if ([Enterprise array:imagesByServer containImageEnterprise:imageEnterprise] ==  NO) {
                [[Enterprise instance] removeImagesObject:imageEnterprise];                
            }
        }
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
}
}

+ (BOOL)array:(NSArray*)images containImageEnterprise:(ImageEnterprise*)imageEnterprise
{
    for (ImageEnterprise *myImage in images) {
        if ([myImage.iD isEqualToString:imageEnterprise.iD]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Aux

- (NSString*)fullDescription
{
    return [NSString stringWithFormat:@"%@\n\n%@", self.firstDescription, self.secondDescription];
}

@end
