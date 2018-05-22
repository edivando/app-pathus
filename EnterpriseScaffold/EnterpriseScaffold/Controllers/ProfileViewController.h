//
//  ProfileViewController.h
//  Pathus
//
//  Created by Torquato on 05/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController

- (IBAction)didTouchMenuBtn:(id)sender;
- (IBAction)didTouchUpdateUserBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *birthdateTF;
@property (weak, nonatomic) IBOutlet UITextField *cpfTF;
@property (weak, nonatomic) IBOutlet UITextField *motherTF;

@end
