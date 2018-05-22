//
//  AppDelegate.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 13/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushDelegate <NSObject>

- (void)sendPushTokenToServer;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) id<PushDelegate> pushDelegate;

// Core Data
+ (void)setupCoreData;
+ (void)removeAllFromEntity:(NSString*)entityName;

// Push Token
+ (void)enablePushService;

// NSUserDefaults Aux
+ (void)setIsFirstAppLoad:(BOOL)boolean;
+ (BOOL)isFirstAppLoad;
+ (void)setIsPushTokenSync:(BOOL)boolean;
+ (BOOL)isPushTokenSync;


@end
