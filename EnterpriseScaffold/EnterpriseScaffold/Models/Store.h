//  Store.h
//  DryPhoto
//
//  Created by Lucas Torquato on 10/02/15.
//  Copyright (c) 2015 Lucas Torquato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"
#import "CoreLocation/CoreLocation.h"

@class Annotation;

@interface Store : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * imageURL;

@property (nonatomic, retain) NSNumber * priority;

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;

@property (nonatomic, retain) Annotation * annotation;

+ (RKObjectMapping*)mapping;
- (CLLocationCoordinate2D)coordinate;

+ (NSArray*)allStoresByPriority;

+ (void)synchronizeFromServer:(NSArray*)storesFromServer;

@end
