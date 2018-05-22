//
//  ProductDetailViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 10/28/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Product, ProductsViewController;

@interface ProductDetailViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sectionImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptiontext;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (weak, nonatomic) IBOutlet UIButton *contactBtn;

@property (weak, nonatomic) Product *product;
@property (weak, nonatomic) ProductsViewController *productVCReference;

- (IBAction)clickPageControl:(id) sender;

- (IBAction)didTouchBackBtn:(id)sender;

- (IBAction)didTouchPayBtn:(id)sender;
- (IBAction)didTouchShareBtn:(id)sender;
- (IBAction)didTouchFriendBtn:(id)sender;

@end
