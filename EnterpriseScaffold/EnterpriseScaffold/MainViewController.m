//
//  ViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 13/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "MainViewController.h"
#import "SectionViewController.h"
#import "SectionClient.h"
#import "EnterpriseConfig.h"
#import "SVProgressHUD.h"
#import "Section.h"
#import "ProductsViewController.h"
#import "EnterpriseInfoViewController.h"
#import "NewsViewController.h"
#import "ContactViewController.h"
#import "Product.h"

#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "LoginViewController.h"

#import "SectionClient.h"
#import "EnterpriseClient.h"
#import "ExamClient.h"

#import "Enterprise.h"
#import "UserClient.h"


@interface MainViewController ()
{
    BOOL _isTimerLoaded;
    NSTimer *_backgroundTimer;
    NSUInteger _imagePage;
    NSArray *_backgroundImages;
    BOOL _transitioning;
    CGRect _animatedRect;
}

@end

@implementation MainViewController 

#pragma mark - Requests

- (void)loadEnterpriseOnSuccess:(void (^)(void))successBlock onError:(void (^)(NSError *))errorBlock;
{
    // Get Enterprise Info
    [SVProgressHUD showWithStatus:@"Carregando..." maskType:SVProgressHUDMaskTypeBlack];
    [[EnterpriseClient sharedInstance] allWithEnterpriseID:[[EnterpriseConfig sharedInstance]iD] onSuccess:^(NSArray *result) {
        
        Enterprise *enterpriseServer = (Enterprise*)result[0];
        [Enterprise synchronizeImages:enterpriseServer.images.allObjects];
        
        successBlock();
        
    } onError:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Error ao atualizar informações..."];
        
        errorBlock(error);
    }];
}

- (void)loadAllSections
{
    // Get All Sections With Products
    [[SectionClient sharedInstance] allWithEnterpriseID:[[EnterpriseConfig sharedInstance] iD] onSuccess:^(NSArray *sections) {
        
        [SVProgressHUD dismiss];
        
        // Send token request - anonymous
        if([User pushToken] == nil || [[User pushToken] isEqualToString:@""]){
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.pushDelegate = self;
            [AppDelegate enablePushService];
        }
        
    } onError:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"Erro ao tentar atualizar as sessões..."];
        NSLog(@"FALIED");
        
    }];
}

- (void)renewTokenRequest
{
    if ([User isUserLogged]) {
        [[UserClient sharedInstance] renewTokenWithCredentials:[User userCredentials] onSuccess:^(NSString *token) {
            [User setUserCredentials:@{@"authentication_token" : token , @"login" : [[User userCredentials] objectForKey:@"login"] }];
            [User insertCredentialsOnHTTPClient:[[UserClient sharedInstance] HTTPClient]];
            [User insertCredentialsOnHTTPClient:[[ExamClient sharedInstance] HTTPClient]];
            [User insertCredentialsOnHTTPClient:[[EnterpriseClient sharedInstance] HTTPClient]];
            [User insertCredentialsOnHTTPClient:[[SectionClient sharedInstance] HTTPClient]];
        } onError:^(NSError *error) {
            NSLog(@"Renew Token error: %@",error);
        }];
    }
}


#pragma mark PushDelegate

- (void)sendPushTokenToServer
{
    [[UserClient sharedInstance] saveAnonymousPushToken:[User pushToken] onSuccess:^{
        NSLog(@" Anonymous token saved.");
    } onError:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SectionClient *sectionClient =[SectionClient sharedInstance];
    [sectionClient.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            [AppDelegate removeAllFromEntity:@"Section"];
        }
        
        [self loadEnterpriseOnSuccess:^{
            [self loadAllSections];
        } onError:^(NSError *error) {
            NSLog(@"Não funfou!");
            [self loadAllSections];
        }];
        
    }];
    
    //
    [self renewTokenRequest];
    
    //_backgroundImages = @[@"bg1.jpg"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if ([User isShowExamsVC]) {
        [User setShowExamsVC:NO];
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ExamsViewControllerNAV"]
                           animated:YES completion:nil];
    }
    
    //
    if ([User isUserLogged]) {
        [self.loginBtn setTitle:[NSString stringWithFormat:@"Usuário: %@",[[User sharedUser] name]] forState:UIControlStateNormal];
        self.loginBtn.hidden = NO;
    }else{
        self.loginBtn.hidden = YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didTouchExamsBtn
{
    if ([User isUserLogged]) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ExamsViewControllerNAV"]
                           animated:YES completion:nil];
    }else{
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerNAV"]
                           animated:YES completion:nil];
    }
}

- (IBAction)didTouchServicesBtn
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SectionViewControllerNAV"]
                       animated:YES completion:nil];
}

- (IBAction)didTouchEnterpriseBtn
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EnterpriseInfoViewControllerSimple"]
                       animated:YES completion:nil];
}

- (IBAction)didTouchContactBtn
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"]
                       animated:YES completion:nil];
}

- (IBAction)didTouchLoginBtn
{
//    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerNAV"]
//                       animated:YES completion:nil];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - AUX

- (UIViewController*)viewControllerForSection:(Section*)section
{
    UIViewController *controller = nil;
    if (!section || section.sections.count > 0) {
        SectionViewController *sectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionViewController"];
        sectionViewController.section = section;
        sectionViewController.isSubsection = YES;
        
        UIView *titleView;
        if (section.priority.integerValue == 0) //services menu
        {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,130,33)];
            UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10,0,130,33)];
            titleImageView.image = [UIImage imageNamed:@"navigation-bar-service.png"];
            [titleView addSubview:titleImageView];
            
        }
        else //products menu
        {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,153,33)];
            UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15,0,153,33)];
            titleImageView.image = [UIImage imageNamed:@"navigation_bar_product.png"];
            [titleView addSubview:titleImageView];
        }
        
        
        sectionViewController.titleView = titleView;
        controller = (UIViewController*)sectionViewController;
        
    }else{
        ProductsViewController *productsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsViewController"];
        productsViewController.section = section;
        productsViewController.isMaster = YES;
        controller = (UIViewController*)productsViewController;
        
    }
    
    return controller;
}

-(BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}

#pragma mark - Background Animations

- (void)fadeAction
{
//    [UIView animateWithDuration:4.5 animations:^{
//        
//        //NSLog(@"self.backgroundImageView.center.x + 30 = %f, self.view.center.x = %f", self.backgroundImageView.center.x + 30, self.view.center.x + 30);
//        //CGFloat animatedCenterX = MIN(self.backgroundImageView.center.x + 30, self.view.center.x + 30);
//        //self.backgroundImageView.center = CGPointMake(animatedCenterX, self.backgroundImageView.center.y);
//        
//    } completion:^(BOOL finished) {
//        
////        [UIView transitionWithView:self.backgroundImageView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
////            
////            if (!_transitioning) {
////                _imagePage = ++_imagePage % _backgroundImages.count;
////                self.backgroundImageView.image = [UIImage imageNamed:_backgroundImages[_imagePage]];
////                
////            }
////            
////        } completion:^(BOOL finished) {
////            
////        }];
//        
//    }];

}

@end
