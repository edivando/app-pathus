//
//  LoginPreviewViewController.h
//  Pathus
//
//  Created by Torquato on 25/08/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

- (IBAction)didTouchMenuBtn:(id)sender;

@end
