//
//  TopEnterInfoViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopEnterInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *BackBtn;

- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight;

- (IBAction)didTouchBackBtn:(id)sender;

@end
