//
//  NSManagedObject+Utility.m
//  Pathus
//
//  Created by Torquato on 10/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "NSManagedObject+Utility.h"
#import <RestKit/RestKit.h>

@implementation NSManagedObject (Utility)

+ (id)createEntity
{
    NSString *className = NSStringFromClass([self class]);
    
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
}

+ (void)removeAllObjects
{
    NSString *className = NSStringFromClass([self class]);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *itens = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *item in itens) {
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:item];
    }
    NSError *saveError = nil;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&saveError];
}

+ (NSArray*)getAll
{
    NSString *className = NSStringFromClass([self class]);
    
    return [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:className] error:nil];
}

+ (id)getByID:(NSString*)iD
{
    NSString *className = NSStringFromClass([self class]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"iD == %@", iD]];
    
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:nil];
    return result.firstObject;
}

+ (BOOL)existByID:(NSString*)iD
{
    return ([[self class] getByID:iD] != nil);
}

- (void)deleteMe
{
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:self];
}


@end
