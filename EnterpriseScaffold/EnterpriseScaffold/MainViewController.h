//
//  ViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 13/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainViewController : UIViewController <PushDelegate> /* Uncomment this if using the auto slide effect to background images -> <LESliderMainViewControllerDelegate>*/

@property (weak, nonatomic) IBOutlet UIButton *servicesBtn;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;

@property (weak, nonatomic) IBOutlet UIButton *enterpriseBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIView *backgroundContainerView;

- (IBAction)didTouchExamsBtn;
- (IBAction)didTouchServicesBtn;
- (IBAction)didTouchEnterpriseBtn;
- (IBAction)didTouchContactBtn;
- (IBAction)didTouchLoginBtn;

@end
