//
//  NSManagedObject+Utility.h
//  Pathus
//
//  Created by Torquato on 10/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Utility)

+ (id)createEntity;
+ (void)removeAllObjects;
- (void)deleteMe;

+ (NSArray*)getAll;
+ (BOOL)existByID:(NSString*)iD;
+ (id)getByID:(NSString*)iD;

@end
