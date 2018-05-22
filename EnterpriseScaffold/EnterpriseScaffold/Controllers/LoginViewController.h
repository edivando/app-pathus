//
//  LoginViewController.h
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;

@property (nonatomic, strong) MainViewController *mainVCReference;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)didTouchLoginBtn:(id)sender;
- (IBAction)didTouchForgotPassBtn:(id)sender;

@end
