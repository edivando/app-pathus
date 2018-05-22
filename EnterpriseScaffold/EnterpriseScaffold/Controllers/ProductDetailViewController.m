//
//  ProductDetailViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 10/28/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "SVProgressHUD.h"
#import "ImageProduct.h"
#import "Section.h"
#import "ProductsViewController.h"

#import "DesignConfig.h"
#import "Enterprise.h"

#import "Utils.h"

#import <QuartzCore/QuartzCore.h>


#define BANNER_WIDTH 300

#define BANNER_HEIGHT_4INCH 185
#define BANNER_HEIGHT 185

@interface ProductDetailViewController ()

@property (nonatomic, strong) UIActivityViewController *activityViewController;

@property (nonatomic, assign) NSUInteger bannerHeight;

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Config Image Scroll
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = NO;
    self.imagesScrollView.scrollEnabled = NO;
    self.imagesScrollView.contentSize = CGSizeMake(self.product.images.allObjects.count*BANNER_WIDTH, self.bannerHeight);
    
    
    self.bannerHeight = ([self hasFourInchDisplay]) ? BANNER_HEIGHT_4INCH : BANNER_HEIGHT;
    
    // Load View
    [self loadImagesScrollView];
    
    // Set Infos
    self.title = self.product.name;
    //[self setNameLabelText: self.product.name];
    
    // Section
    if (![self.product.section.imageURL isEqualToString:@""]) {
        [self.product.section imageInView:self.sectionImageView onSuccess:^(UIImage *image, BOOL isNew) {
            
            [self.sectionImageView setImage:image];
            
        } onError:nil];
    }else{
        //self.sectionNameLabel.text = self.product.section.name;
    }
    
    // Description
    self.descriptiontext.text = self.product.descriptionText;
    [self.descriptiontext setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [self.descriptiontext setTextAlignment:NSTextAlignmentJustified];
    [self.descriptiontext setTextColor:PRODUCT_TEXT_COLOR];

    
    self.contactBtn.layer.borderColor = PURPLE_COLOR.CGColor;
    self.contactBtn.layer.borderWidth = 1.0;
    [self.contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    //drawing shadow for footer
//    self.footerView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.footerView.layer.shadowOpacity = 0.3f;
//    self.footerView.layer.shadowOffset = CGSizeMake(2.0f, -0.5f);
//    self.footerView.layer.shadowRadius = 3.0f;
//    self.footerView.layer.masksToBounds = NO;
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.footerView.bounds];
//    self.footerView.layer.shadowPath = path.CGPath;
//    
//    
//    
//    
//    //drawing shadow for footer
//    self.separatorLine.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.separatorLine.layer.shadowOpacity = 0.2f;
//    self.separatorLine.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
//    self.separatorLine.layer.shadowRadius = 3.0f;
//    self.separatorLine.layer.masksToBounds = NO;
//    
//    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:self.separatorLine.bounds];
//    self.separatorLine.layer.shadowPath = path2.CGPath;
//    
    

    
//    self.descriptiontext.layer.masksToBounds = YES;
//    self.descriptiontext.layer.borderWidth = 1.0;
//    self.descriptiontext.layer.borderColor = PRODUCT_TEXT_COLOR.CGColor;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchPayBtn:(id)sender
{
    if ([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

        [picker.navigationBar setTintColor:TINT_COLOR];
        picker.mailComposeDelegate = self;
        [picker setSubject:[NSString stringWithFormat:@"Contato - %@",self.product.name]];
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"contato@email.com"];
        
        [picker setToRecipients:toRecipients];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Dispositivo não está configurado para enviar e-mail."];
    }
}

- (IBAction)didTouchShareBtn:(id)sender
{
    NSString *text = [NSString stringWithFormat:@"%@ via %@ APP", [[Enterprise instance] name], self.product.name];
    
    NSMutableArray *itens = [NSMutableArray new];
    [itens addObject:text];
    if (self.product.images.count > 0) {
        [itens addObject:self.product.images.allObjects.lastObject];
    }
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itens applicationActivities:nil];
    self.activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

- (IBAction)didTouchFriendBtn:(id)sender
{
    if ([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
      
        [picker setSubject:@"Beleza Fashion APP"];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Dispositivo não está configurado para enviar e-mail."];
    }
}

#pragma mark - Image Scroll

- (void)loadImagesScrollView
{
    int i = 0;
    for (ImageProduct *imgProduct in self.product.images.allObjects) {
        
        UIImageView *imageView = [UIImageView new];
        [imageView setContentMode:UIViewContentModeCenter];
        
        [imgProduct imageInView:imageView onSuccess:^(UIImage *image, BOOL isNew) {
            [imageView setImage:image];
            [self addImageView:imageView inHeaderScroolOrder:i];
        } onError:nil];
        i++;
    }
    
    [self finishBuildImagesScrollView];
}
     
- (void)addImageView:(UIImageView*)imageView inHeaderScroolOrder:(int)order
{
    imageView.frame = CGRectMake((order)*BANNER_WIDTH, 0, BANNER_WIDTH, self.bannerHeight);
    [self.imagesScrollView addSubview:imageView];
}

- (void)finishBuildImagesScrollView
{
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.scrollEnabled = YES;
    
    self.pageControl.numberOfPages = self.product.images.allObjects.count;
    self.pageControl.currentPage = 0;

    self.pageControl.hidden = !(self.product.images.allObjects.count > 1);
}

#pragma mark - Scroll Delegate and Page Control

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (IBAction)clickPageControl:(id) sender
{
    NSInteger page = self.pageControl.currentPage;
    
    CGRect frame = self.imagesScrollView.frame;
    
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [self.imagesScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[SVProgressHUD showErrorWithStatus:@"Enviar e-mail - cancelado"];
			break;
		case MFMailComposeResultSaved:
			[SVProgressHUD showSuccessWithStatus:@"E-Mail salvo"];
			break;
		case MFMailComposeResultSent:
			[SVProgressHUD showSuccessWithStatus:@"E-Mail enviado"];
			break;
		case MFMailComposeResultFailed:
			[SVProgressHUD showErrorWithStatus:@"Enviar E-Mail - falhou"];
			break;
		default:
			[SVProgressHUD showErrorWithStatus: @"E-Mail não enviado"];
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Layout

-(void)setupCustomBackButton
{
    //setting up new button on left
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont fontWithName:button.titleLabel.font.fontName size:13.0];
    
    NSString *title = @"Voltar";
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(didTouchBackBtn:) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:[UIImage imageNamed:@"custom_back_button.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"custom_back_button_selected.png"] forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 70 + 3.12*title.length, 33);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navBar.topItem.leftBarButtonItem = barButton;
}

-(NSString*)truncateString:(NSString*)string afterLength:(NSUInteger)length
{
    if (string.length > length) {
        string = [string substringToIndex: MAX(3, length)];
        string = [NSString stringWithFormat:@"%@...", string];
    }
    
    return string;
}

-(void)setNameLabelText:(NSString*)text
{
    self.nameLabel.text = [NSString stringWithFormat:@" %@   ", text];
}

@end
