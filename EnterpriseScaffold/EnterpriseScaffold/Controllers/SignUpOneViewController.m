//
//  SignUpViewController.m
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "SignUpOneViewController.h"
#import "User.h"
#import <RestKit/RestKit.h>
#import "SignUpTwoViewController.h"

#import "Utils.h"

#import "NSDate+Utility.h"

@interface SignUpOneViewController ()

@property (nonatomic, copy) NSDate *birthDate;

@end

@implementation SignUpOneViewController

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
    
    [Utils applyBorder:self.continueBtn];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didChangeBirthdateValue:) forControlEvents:UIControlEventValueChanged];
    self.birthdateTF.inputView = datePicker;
    self.user.birthdate = [NSDate date];

    self.continueBtn.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Inscrever-se";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Bithdate Date Picker

- (void)didChangeBirthdateValue:(UIDatePicker*)datePicker
{
    self.continueBtn.enabled = YES;
    
    self.birthdateTF.text = [datePicker.date formatToBRStr];
    
    self.birthDate = [datePicker.date copy];
}

#pragma mark - Validations

- (BOOL)isValidFields
{
    BOOL isValid = YES;
    
    NSString *name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cpf = [self.cpfTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contact = [self.contactTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *birthdate = [self.birthdateTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    if ([name isEqualToString:@""] || name == nil) {
        [errorString appendString:@"- O Nome não pode ser vazio"];
        isValid = NO;
    }
    
    if ([cpf isEqualToString:@""] || cpf == nil) {
        [errorString appendString:@"\r- O CPF não pode ser vazio"];
        isValid = NO;
    }
    
    if ([contact isEqualToString:@""] || contact == nil) {
        [errorString appendString:@"\r- O Número de Contato não pode ser vazio"];
        isValid = NO;
    }
    
    if ([birthdate isEqualToString:@""] || birthdate == nil) {
        [errorString appendString:@"\r- A Data de Nascimento não pode ser vazio"];
        isValid = NO;
    }
    
    if (!isValid) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Por Favor" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    return isValid;
}

#pragma mark - Override Segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.title = @"Voltar";
    if ([segue.identifier isEqualToString:@"SignUpTwoSegue"]) {
        SignUpTwoViewController *signUpTwoVC = (SignUpTwoViewController*)[segue destinationViewController];
        signUpTwoVC.user = self.user;
    }
}
#pragma mark - Actions

- (IBAction)didTouchContinueButton:(id)sender {
    
    if([self isValidFields])
    {
        if (!self.user) {
            self.user = [[User alloc]initWithEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext] insertIntoManagedObjectContext:nil];
        }

        self.user.name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.user.cpf = [self.cpfTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.user.telephone = [self.contactTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.user.birthdate = self.birthDate;
        
        [self performSegueWithIdentifier:@"SignUpTwoSegue" sender:nil];
    }

}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
