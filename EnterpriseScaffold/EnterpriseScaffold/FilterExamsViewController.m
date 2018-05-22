//
//  FilterExamsViewController.m
//  Pathus
//
//  Created by Torquato on 09/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "FilterExamsViewController.h"

#import "NSString+Utility.h"
#import "NSDate+Utility.h"
#import "UserSearchViewController.h"

@interface FilterExamsViewController () <UITextFieldDelegate, UserSearchDelegate>

@property (nonatomic, strong) UIDatePicker *startDatePicker;
@property (nonatomic, strong) UIDatePicker *endDatePicker;

@end

@implementation FilterExamsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.usernameTF.delegate = self;
    self.startdateTF.delegate = self;
    self.enddateTF.delegate = self;
    
    self.startDatePicker = [[UIDatePicker alloc] init];
    [self.startDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.startDatePicker addTarget:self action:@selector(didChangeStartDateValue:) forControlEvents:UIControlEventValueChanged];
    self.startdateTF.inputView = self.startDatePicker;
    
    self.endDatePicker = [[UIDatePicker alloc] init];
    [self.endDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.endDatePicker addTarget:self action:@selector(didChangeEndDateValue:) forControlEvents:UIControlEventValueChanged];
    
    self.enddateTF.inputView = self.endDatePicker;
    
    self.startDatePicker.maximumDate = [NSDate date];
    self.startDatePicker.date = (self.startdate) ? : [NSDate date];
    
    self.endDatePicker.maximumDate = [NSDate date];
    self.endDatePicker.date = (self.enddate) ? : [NSDate date];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.usernameTF.text = self.username;
    self.startdateTF.text = [self.startdate formatToBRStr];
    self.enddateTF.text = [self.enddate formatToBRStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

#pragma mark Nav Buttons

- (IBAction)didTouchFilterBtn:(id)sender
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate filterExamsByUsername:self.usernameTF.text startdate:[self.startdateTF.text toBRDate] enddate:[self.enddateTF.text toBRDate]];
    }];
    
}

- (IBAction)didTouchBackBtn:(id)sender
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Date Picker

- (void)didChangeStartDateValue:(UIDatePicker*)datePicker
{
    self.startdateTF.text = [datePicker.date formatToBRStr];
    
    self.endDatePicker.minimumDate = datePicker.date;
}

- (void)didChangeEndDateValue:(UIDatePicker*)datePicker
{
    self.enddateTF.text = [datePicker.date formatToBRStr];
    
    self.startDatePicker.maximumDate = datePicker.date;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.usernameTF]){
    
        [self performSegueWithIdentifier:@"UserSearchID" sender:nil];
        
    }else if ([textField isEqual:self.startdateTF]) {
    
        self.startdateTF.text = [self.startDatePicker.date formatToBRStr];
        [self.startDatePicker setDate:self.startDatePicker.date animated:YES];
        
    }else if([textField isEqual:self.enddateTF]){
        
        self.enddateTF.text = [self.endDatePicker.date formatToBRStr];
        [self.endDatePicker setDate:self.endDatePicker.date animated:YES];
        
    }
}

#pragma mark - User Search Delegate

- (void)usernameSelected:(NSString *)username
{
    self.username = username;
}

#pragma mark - Prepare Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserSearchID"]){
        UserSearchViewController *userSearch = segue.destinationViewController;
        userSearch.delegate = self;
    }
}


@end
