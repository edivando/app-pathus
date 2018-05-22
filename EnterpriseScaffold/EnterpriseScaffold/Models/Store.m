//
//  Store.m
//  DryPhoto
//
//  Created by Lucas Torquato on 10/02/15.
//  Copyright (c) 2015 Lucas Torquato. All rights reserved.
//

#import "Store.h"

#import "NSManagedObject+Utility.h"

@implementation Store

@dynamic iD, name, address, telephone, latitude, longitude, imageURL, priority, annotation;

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Store" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id" : @"iD",
                                                  @"name" : @"name",
                                                  @"address" : @"address",
                                                  @"telephone" : @"telephone",
                                                  @"latitude" : @"latitude",
                                                  @"longitude" : @"longitude",
                                                  @"image.url" : @"imageURL",
                                                  @"priority" : @"priority"
                                                  
                                                  }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    return mapping;
}

+ (RKRoute*)route
{
    return [RKRoute routeWithName:@"store" pathPattern:@"store" method:RKRequestMethodGET];
}

#pragma mark -

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D placeCenter;
    placeCenter.latitude = [self.latitude floatValue];
    placeCenter.longitude = [self.longitude floatValue];
    
    return placeCenter;
}

#pragma mark - Sort Stores

+ (NSArray*)allStoresByPriority;
{
    NSArray *allStores = [Store getAll];
    
    return [allStores sortedArrayUsingComparator:^NSComparisonResult(Store *obj1, Store *obj2) {
        return [obj1.priority compare:obj2.priority];
    }];
}

#pragma mark - Synchronize

+ (void)synchronizeFromServer:(NSArray*)storesFromServer
{
    NSArray *allStoresFromDB = [Store getAll];
    
    for (Store *store in allStoresFromDB) {
        if([Store array:storesFromServer containStore:store] == NO){
            [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:store];
        }
    }
    
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:nil];
}

+ (BOOL)array:(NSArray*)stores containStore:(Store*)store
{
    for (Store *myStore in stores) {
        if ([myStore.iD isEqualToString:store.iD]) {
            return YES;
        }
    }
    return NO;
}

@end
