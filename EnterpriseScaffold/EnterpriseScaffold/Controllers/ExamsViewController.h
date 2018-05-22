//
//  ExamsViewController.h
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamCell.h"
#import "AppDelegate.h"

@class LoginViewController;

@interface ExamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ExamsDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) LoginViewController *loginVCReference;
@property (weak, nonatomic) IBOutlet UILabel *noExamsLabel;

- (IBAction)didTouchBackBtn:(id)sender;
- (IBAction)didTouchLogoutBtn:(id)sender;
- (IBAction)didTouchFilterBtn:(id)sender;

@end
