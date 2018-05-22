//
//  ImagePost.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@class Post;

@interface ImagePost : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * postID;

@property (nonatomic, retain) Post * post;

+ (RKObjectMapping*)mapping;
+ (void)insertAndSaveNewImagePost:(UIImage*)image toPost:(Post*)post inContext:(NSManagedObjectContext*)context;

- (void)imageInView:(UIImageView*)imageView onSuccess:(void (^)(UIImage *image, BOOL isNew))successBlock onError:(void (^)(NSError *error))errorBlock;

//+ (void)contextDidSave:(NSNotification *)notification;
//+ (void)synchronizeImagesWithProducts;

@end
