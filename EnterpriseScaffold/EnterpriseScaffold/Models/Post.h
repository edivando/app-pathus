//
//  Post.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@interface Post : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;

@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSString * videoImageCoverURL;

@property (nonatomic, retain) NSSet * images;

+ (NSArray*)getAllOrderByDate;

// Core Data Sync
+ (void)synchronizePosts:(NSArray*)postByServer;
+ (BOOL)array:(NSArray*)posts containPost:(Post*)post;

@end
