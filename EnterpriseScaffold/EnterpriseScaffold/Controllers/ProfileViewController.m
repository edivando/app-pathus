//
//  ProfileViewController.m
//  Pathus
//
//  Created by Torquato on 05/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "ProfileViewController.h"

#import "SVProgressHUD.h"

#import "UserClient.h"

#import "User.h"

#import "NSDate+Utility.h"

@interface ProfileViewController ()

@property (nonatomic, weak) User *user;

@end

@implementation ProfileViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User sharedUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didChangeBirthdateValue:) forControlEvents:UIControlEventValueChanged];
    self.birthdateTF.inputView = datePicker;
    
    [self.emailTF becomeFirstResponder];
    
    [self prepopulateForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bithdate Date Picker

- (void)didChangeBirthdateValue:(UIDatePicker*)datePicker
{
    self.birthdateTF.text = [datePicker.date formatToBRStr];
    
    self.user.birthdate = datePicker.date;
}

#pragma mark - User

- (void)prepopulateForm
{
    self.emailTF.text = [self.user email];
    self.nameTF.text = [self.user name];
    self.phoneTF.text = [self.user celphone];
    
    self.birthdateTF.text = [[self.user birthdate] formatToBRStr];
    self.cpfTF.text = [self.user cpf];
    self.motherTF.text = [self.user motherName];
}

#pragma mark - Actions

- (IBAction)didTouchMenuBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view endEditing:NO];
}

- (IBAction)didTouchUpdateUserBtn:(id)sender
{
    if ([self isValidFields]) {
        [SVProgressHUD showWithStatus:@"Atualizando..." maskType:SVProgressHUDMaskTypeGradient];
        [[UserClient sharedInstance] updateUser:[self formToDic] onSuccess:^(User *user) {
            
            [SVProgressHUD showSuccessWithStatus:@"Atualizado com sucesso"];
            
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        } onError:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Verifique sua conexão"];
        }];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [User logout];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Address Form

- (NSDictionary*)formToDic
{
    return @{
             @"email" : self.emailTF.text,
             @"name" : self.nameTF.text,
             @"celphone" : self.phoneTF.text,
             @"telephone" : self.phoneTF.text,
             @"cpf" : self.cpfTF.text,
             @"mother_name" : self.motherTF.text,
             @"birth_date" : self.birthdateTF.text
             };
}

#pragma mark - Validations

- (BOOL)isValidFields
{
    __block BOOL isValid = YES;

    NSString *email = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *cpf = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *motherName = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *birthDate = [self.emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    [self checkValidationToField:email usingFieldName:@"Email" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
    
    [self checkValidationToField:name usingFieldName:@"Name" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
    
    [self checkValidationToField:phone usingFieldName:@"Celular" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
    
    [self checkValidationToField:cpf usingFieldName:@"CPF" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
    
    [self checkValidationToField:motherName usingFieldName:@"Nome da Mãe" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
    
    [self checkValidationToField:birthDate usingFieldName:@"Data de Nascimento" withErrorHandling:^(NSString *errorMsg) {
        [errorString appendString:errorMsg];
        isValid = NO;
    }];
  
    if (!isValid) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Por Favor" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    return isValid;
}

- (void)checkValidationToField:(NSString*)field usingFieldName:(NSString*)fieldName withErrorHandling:(void (^)(NSString *errorMsg))errorHandling
{
    if ([field isEqualToString:@""] || field == nil) {
        NSString *errorMsg = [NSString stringWithFormat:@"\r- O %@ não pode ser vazio", fieldName];
        errorHandling(errorMsg);
    }
}

#pragma mark - UIKeyboard

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,460)];
}


@end
