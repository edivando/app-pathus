//
//  SignUpTwoViewController.m
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "SignUpTwoViewController.h"
#import "User.h"
#import "UserClient.h"
#import "SVProgressHUD.h"
#import "MF_Base64Additions.h"
#import "AFHTTPRequestOperation+Utility.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "SignUpOneViewController.h"

#import "NSString+Utility.h"
#import "EnterpriseConfig.h"

#import "Utils.h"

@interface SignUpTwoViewController ()

@end

@implementation SignUpTwoViewController

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
    
    self.title = @"Inscrever-se";
    
    [Utils applyBorder:self.finalizeBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.emailTF.text = self.user.email;
    self.passwordTF.text = self.user.password;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    SignUpOneViewController *prevController = self.navigationController.viewControllers[1];
    
    self.user.email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.user.password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    prevController.user = self.user;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Request

- (void)signUpRequest
{
    [SVProgressHUD showWithStatus:@"Criando Usuário..." maskType:SVProgressHUDMaskTypeClear];
    [[UserClient sharedInstance] signUpWithUserData:self.user onSuccess:^(User *user) {
        [SVProgressHUD dismiss];
    
        [User setShowExamsVC:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:[operation translateValidationError]];
    }];
}

#pragma mark - Validations

- (BOOL)isValidFields
{
    BOOL isValid = YES;
    NSString *email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pss = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pssConf = [self.passwordConfTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *motherName = [self.motherNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    // Email
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        [errorString appendString:@"- O email é inválido"];
        isValid = NO;
    }
    
    // Password
    if (![pss isEqualToString:pssConf]) {
        [errorString appendString:@"\r- O password de confirmação está errado"];
        isValid = NO;
    }
    if (pss.length < 4) {
        [errorString appendString:@"\r- O password deve conter pelo menos 4 caracteres"];
        isValid = NO;
    }
    
    if ([motherName isEqualToString:@""] || motherName == nil) {
        [errorString appendString:@"\r- O Nome da Mãe não pode ser vazio"];
        isValid = NO;
    }
    
    if (!isValid) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Por Favor" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    return isValid;
}

#pragma mark - Actions


- (IBAction)didTouchFinalizeButton:(id)sender {
    
    if ([self isValidFields]) {
        
        self.user.email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.user.password = [[self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] sha512StringWithHMACKey:ES_HASH_KEY];
        self.user.motherName = [self.motherNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [self.view endEditing:YES];
        
        [self signUpRequest];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
