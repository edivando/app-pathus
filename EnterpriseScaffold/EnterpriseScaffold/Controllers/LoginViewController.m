//
//  LoginViewController.m
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "LoginViewController.h"
#import "UserClient.h"
#import "SVProgressHUD.h"
#import "MF_Base64Additions.h"
#import "MainViewController.h"
#import "AFHTTPRequestOperation+Utility.h"

#import "DesignConfig.h"
#import "User.h"

#import "NSString+Utility.h"
#import "EnterpriseConfig.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () <UIAlertViewDelegate>

@property(nonatomic,assign) BOOL isEmailTFValid;
@property(nonatomic,assign) BOOL isPasswordTFValid;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set TF Delegate
    self.emailTF.delegate = self;
    self.passwordTF.delegate = self;
    
    // Set Default Config
    self.passwordTF.secureTextEntry = YES;
    self.loginBtn.enabled = NO;
    self.loginBtn.alpha = 0.5;
    
    [self addBorderAllButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    
    //[self.emailTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)addBorderAllButtons
{
    CGColorRef borderColor = PURPLE_COLOR.CGColor;
    
    self.loginBtn.layer.borderColor = borderColor;
    self.forgotBtn.layer.borderColor = borderColor;
    
    CGFloat borderWidth = 1.0;
    self.loginBtn.layer.borderWidth = borderWidth;
    self.forgotBtn.layer.borderWidth = borderWidth;
}

#pragma mark - Requests

- (void)forgetPasswordRequestWithEmail:(NSString*)email
{
    [SVProgressHUD showWithStatus:@"Verificando o Email..." maskType:SVProgressHUDMaskTypeClear];
    [[UserClient sharedInstance] forgetPasswordWithLogin:email onSuccess:^(User *user) {
        
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Esqueci a senha" message:@"Você receberá um email com as informações sobre o novo código de acesso em poucos minutos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Não existe usuário com esse email: %@", email]];
    }];
    
}

#pragma mark - Actions

- (IBAction)didTouchCancelBTn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)didTouchLoginBtn:(id)sender
{
    NSString *login = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([login rangeOfString:@"@"].location == NSNotFound) { //if the login is not an e-mail, it should be a cpf. String all non-numerical characters in this case
        login = [login stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [login length])];
    }
    
    NSString *pss = [[self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] sha512StringWithHMACKey:ES_HASH_KEY];
    
    [SVProgressHUD showWithStatus:@"Fazendo Login..." maskType:SVProgressHUDMaskTypeClear];
    [[UserClient sharedInstance] loginWithCredentials:login password:pss onSuccess:^(User *user) {
        [SVProgressHUD dismiss];
        
        [User setShowExamsVC:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[operation translateOperationError]];
    }];
}

- (IBAction)didTouchForgotPassBtn:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Esqueci a senha" message:@"Insira o seu email:" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *email = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self forgetPasswordRequestWithEmail:email];
    }
}

#pragma mark - Textfield Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString *stringComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.emailTF) {
        self.isEmailTFValid = [self isValidStrLogin:stringComplete];
    }else{
        self.isPasswordTFValid = (stringComplete.length >= 4);
    }
    
    self.loginBtn.enabled = (self.isEmailTFValid && self.isPasswordTFValid);
    self.loginBtn.alpha = (self.loginBtn.enabled) ? 1 : 0.5;
    
    return YES;
}

- (BOOL)isValidStrLogin:(NSString*)str
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL cpfTest = [str rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
    
    return ([emailTest evaluateWithObject:str] || cpfTest);
}

@end
