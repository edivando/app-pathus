//
//  AppDelegate.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 13/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "Section.h"
#import "Product.h"
#import "User.h"
#import "DesignConfig.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:TINT_COLOR];
    [[UINavigationBar appearance] setBarTintColor:NAV_BAR_COLOR];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                NSForegroundColorAttributeName: TINT_COLOR,
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f]
     }];
    
    // Config Log - Restkit
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Config DB
    [AppDelegate setupCoreData];

    if ([AppDelegate isFirstAppLoad]) {
        [User resetKeychain];
        [User setPushToken:nil];
        
        [AppDelegate setIsFirstAppLoad:NO];
    }
    
    // Reset Push Badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // DB Seed
    //[self runSeed];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Service

+ (void)enablePushService
{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark  Notification Manage

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerta" message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Device token: %@",deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@", [deviceToken description]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"token string: %@", token);
    [User setPushToken:token];
        
    [self.pushDelegate sendPushTokenToServer];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed: %@",error);
}

#pragma mark - NSUserDefaults Aux

+ (void)setIsFirstAppLoad:(BOOL)boolean
{
    [[NSUserDefaults standardUserDefaults] setBool:boolean forKey:@"isFirstAppLoad"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstAppLoad
{
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstAppLoad"];
    if (value == nil) {
        return YES;
    }
    return [value boolValue];
}

+ (void)setIsPushTokenSync:(BOOL)boolean
{
    [[NSUserDefaults standardUserDefaults] setBool:boolean forKey:@"isPushTokenSync"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isPushTokenSync
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isPushTokenSync"];
}

#pragma mark - Seed DB

- (void)runSeed
{
    NSError *error = nil;
    NSArray *sections = [[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] executeFetchRequest:[[NSFetchRequest alloc]  initWithEntityName:@"Section"] error:&error];
    
    if (sections.count > 0) {
        return;
    }
    
    /*** MASTER ***/
    
    Section *menuMaster = [self createSectionWithName:@"Cardápio" descritionText:@"Lorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem Lorem"];
    
    /* ENTRADAS  */
    
    Section *entradasSectionMASTER = [self createSectionWithName:@"Entradas" descritionText:@"Lorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem Lorem"];
    
    Product *antepasto3opcoes = [self createProductWithName:@"Antepasto com 3 Opções" descriptionText:@"Acompanha cascalhos de pizza com alecrim." price:[NSNumber numberWithFloat:13.50] andSection:entradasSectionMASTER];
    
    Product *antepasto5opcoes = [self createProductWithName:@"Antepasto com 5 Opções" descriptionText:@"Acompanha cascalhos de pizza com alecrim." price:[NSNumber numberWithFloat:17.50] andSection:entradasSectionMASTER];
    
    Product *casquinhaDoChef = [self createProductWithName:@"Casquinha do Chef" descriptionText:@"Casquinha gratinada com parmesão e especiarias." price:[NSNumber numberWithFloat:20.00] andSection:entradasSectionMASTER];
    
    Product *saladasDoChef = [self createProductWithName:@"Saladas do Chef" descriptionText:@"Tomate seco, tomate fresco, alface americana, rúcula, azeitonas verdes e pretas, lascas de parmesão, gergelim e molho especial." price:[NSNumber numberWithFloat:20.00] andSection:entradasSectionMASTER];
    
    [entradasSectionMASTER addProducts:[NSSet setWithObjects:antepasto3opcoes,antepasto5opcoes,casquinhaDoChef,saladasDoChef, nil]];
    
    entradasSectionMASTER.belongs_section = menuMaster;
    
    /* MASSA */
    
    
    Section *massasSectionMASTER = [self createSectionWithName:@"Massas" descritionText:@"Lorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem Lorem"];
    
    massasSectionMASTER.belongs_section = menuMaster;
    
        /* - Originais */
    
    Section *massasSection = [self createSectionWithName:@"Massas Originais" descritionText:@"Lorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem Lorem"];
    
    Product *camaraoVignoli = [self createProductWithName:@"Camarão Vignoli" descriptionText:@"Camarão, aliche, alcaparras, ervas e pimenta calabresa, refogados ao alho" price:[NSNumber numberWithFloat:28.80] andSection:massasSection];
    
    Product *penneEspecial = [self createProductWithName:@"Penne Especial Calabresa" descriptionText:@"Refogado levemente picante de calabresa, azeitona preta, alho e ervas" price:[NSNumber numberWithFloat:28.80] andSection:massasSection];
    
    Product *putanesca = [self createProductWithName:@"Putanesca" descriptionText:@"Pomodoro, alcaparras, anchova e azeitonas pretas" price:[NSNumber numberWithFloat:28.80] andSection:massasSection];
    
    Product *rebecca = [self createProductWithName:@"Rebecca" descriptionText:@"Creme de leite, filetes de presunto de peru defumado e ervas" price:[NSNumber numberWithFloat:28.80] andSection:massasSection];
    
    [massasSection addProducts:[NSSet setWithObjects:camaraoVignoli, penneEspecial, putanesca, rebecca, nil]];
    
        /* - Gratinadas */    
    
    Section *massasGratinadas = [self createSectionWithName:@"Massas Gratinadas" descritionText:@"Lorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem LoremLorem Lorem"];
    
    Product *caneloniCamarao = [self createProductWithName:@"Caneloni de Camarão" descriptionText:@"Massa caseira, camarão c/ alho e ervas, catupiry, gratinado c/ molho pomodoro e queijo parmesão" price:[NSNumber numberWithFloat:28.80] andSection:massasGratinadas];
    
    Product *lasagna = [self createProductWithName:@"Lasagna" descriptionText:@"Massa caseira, molho bechamel, presunto defumado de peru, molho de tomate gratinado c/ mussarela" price:[NSNumber numberWithFloat:28.80] andSection:massasGratinadas];
    
    Product *lasagnaBacalhau = [self createProductWithName:@"Lasagna de Bacalhau" descriptionText:@"Massa caseira, bechamel, bacalhau, tomate, cebola, alho e pimentão vermelho" price:[NSNumber numberWithFloat:28.80] andSection:massasGratinadas];
    
    Product *rondelle = [self createProductWithName:@"Rondelle" descriptionText:@"Massa caseira, presunto defumado de peru, mussarela, catupiry e molho de tomate c/ manjericão" price:[NSNumber numberWithFloat:28.80] andSection:massasGratinadas];
    
    [massasGratinadas addProducts:[NSSet setWithObjects:caneloniCamarao, lasagna, lasagnaBacalhau, rondelle, nil]];
    
    [massasSectionMASTER addSections:[NSSet setWithObjects:massasSection, massasGratinadas, nil]];
    
    /* MENU MASTER*/

    [menuMaster addSections:[NSSet setWithObjects:entradasSectionMASTER, massasSectionMASTER, nil]];

    NSError *executeError = nil;
    if(![[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }

}

- (Section*)createSectionWithName:(NSString*)name descritionText:(NSString*)description
{
    Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    section.name = name;
    section.descriptionText = description;
    
    NSError *executeError = nil;
    if(![[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    
    return section;
}

- (Product*)createProductWithName:(NSString*)name descriptionText:(NSString*)description price:(NSNumber*)price andSection:(Section*)section
{
    Product *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    product.name = name;
    product.descriptionText = description;
    product.price = price;
    product.section = section;
    
    NSError *executeError = nil;
    if(![[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    
    return product;
}

#pragma mark - Core Data

+ (void)setupCoreData
{
    NSError *error = nil;
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"ESDataModel.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{
                                                     NSInferMappingModelAutomaticallyOption: @YES,
                                               NSMigratePersistentStoresAutomaticallyOption: @YES
                                          } error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
}

+ (void)removeAllFromEntity:(NSString*)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *itens = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    //error handling goes here
    for (NSManagedObject *item in itens) {
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:item];
    }
    NSError *saveError = nil;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&saveError];
}

@end
