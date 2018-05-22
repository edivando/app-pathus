//
//  EnterpriseInfoViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//
#import "EnterpriseInfoViewController.h"
#import "Enterprise.h"
#import "EnterpriseClient.h"
#import "EnterpriseConfig.h"
#import "SVProgressHUD.h"
#import "TopEnterInfoViewController.h"

#import "ImageEnterprise.h"

@interface EnterpriseInfoViewController ()

@property (nonatomic, strong) Enterprise *enterprise;
@property (nonatomic, strong) NSArray *images;

@end

@implementation EnterpriseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Enterprise Instance
    self.enterprise = [Enterprise instance];
    self.images = self.enterprise.images.allObjects;
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // Config Image Scroll
    self.imagesScrollView.pagingEnabled = NO;
    self.imagesScrollView.scrollEnabled = NO;
    self.imagesScrollView.contentSize = CGSizeMake(self.images.count*self.imagesScrollView.frame.size.width, self.imagesScrollView.frame.size.height);
    self.pageControl.numberOfPages = self.images.count;
    
    [self loadImagesScrollView];
    
    self.descriptionTextView.text = self.enterprise.fullDescription;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Images Scroll View methods

- (void)loadImagesScrollView
{
    int i = 0;
    for (ImageEnterprise *imgEnterprise in self.images) {
        
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(i*self.imagesScrollView.frame.size.width, 0, self.imagesScrollView.frame.size.width, self.imagesScrollView.frame.size.height)];
        
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        
        [imgEnterprise imageInView:imageView onSuccess:^(UIImage *image, BOOL isNew) {
            [imageView setImage:image];
            [self.imagesScrollView addSubview:imageView];
        } onError:nil];
        i++;
    }
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.scrollEnabled = YES;
}

#pragma mark - Scroll Delegate and Page Control


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
    [self clickPageControl:nil];
}

- (IBAction)clickPageControl:(id) sender
{
    NSInteger page = self.pageControl.currentPage;
    CGRect frame = self.imagesScrollView.frame;
    
    frame.origin.x = page*self.imagesScrollView.frame.size.width;
    frame.origin.y = 0;
    
    [self.imagesScrollView scrollRectToVisible:frame animated:YES];
}

@end
