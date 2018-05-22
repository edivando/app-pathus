//
//  SignUpViewController.h
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface SignUpOneViewController : UIViewController

@property (nonatomic, strong) User * user;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cpfTF;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTF;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

- (IBAction)didTouchContinueButton:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
