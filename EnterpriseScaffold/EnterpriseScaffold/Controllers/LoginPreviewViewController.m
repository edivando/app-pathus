//
//  LoginPreviewViewController.m
//  Pathus
//
//  Created by Torquato on 25/08/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "LoginPreviewViewController.h"

#import "DesignConfig.h"

@interface LoginPreviewViewController ()

@end

@implementation LoginPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBorderAllButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)addBorderAllButtons
{
    CGColorRef borderColor = PURPLE_COLOR.CGColor;
    
    self.loginBtn.layer.borderColor = borderColor;
    self.signUpBtn.layer.borderColor = borderColor;
    
    CGFloat borderWidth = 1.0;
    self.loginBtn.layer.borderWidth = borderWidth;
    self.signUpBtn.layer.borderWidth = borderWidth;
}

#pragma mark - Actions

- (IBAction)didTouchMenuBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
