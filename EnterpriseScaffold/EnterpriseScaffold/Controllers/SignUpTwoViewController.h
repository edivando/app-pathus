//
//  SignUpTwoViewController.h
//  PetProject
//
//  Created by Lucas Torquato on 1/30/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface SignUpTwoViewController : UIViewController

@property (nonatomic, weak) User *user;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfTF;
@property (weak, nonatomic) IBOutlet UITextField *motherNameTF;

@property (weak, nonatomic) IBOutlet UIButton *finalizeBtn;

- (IBAction)didTouchFinalizeButton:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
