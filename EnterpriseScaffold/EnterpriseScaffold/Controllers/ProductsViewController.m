//
//  ProductsViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 30/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ProductsViewController.h"
//#import "ProductSectionCell.h"
#import "Section.h"
#import "Product.h"

#import "ProductDetailViewController.h"
#import "ProductCollCell.h"
#import "SectionTextCell.h"

#import "ImageProduct.h"
#import <QuartzCore/QuartzCore.h>
#import "DesignConfig.h"

@interface ProductsViewController ()

@property (nonatomic, strong) NSArray *childProducts;

@end

@implementation ProductsViewController

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
    
    // Set Delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Get Products order by Priority
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.childProducts = [self.section.products.allObjects sortedArrayUsingDescriptors:sortDescriptors];
    
    // Set Title
    self.title = self.section.name;
    
//    // By Default, show collection first
//    self.isCollectionMode = YES;
//    self.tableView.hidden = YES;
//    self.tableView.alpha = 0.0;
//    [self.viewTypeBtn setSelectedSegmentIndex:0];
    
    
    if (!self.isMaster) {
        [self setupCustomBackButton];
    }
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
    if (self.isMaster) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (IBAction)didTouchViewTypeBtn:(id)sender
//{
//    [UIView animateWithDuration:0.5 animations:^{
//        UISegmentedControl *control = (UISegmentedControl*)sender;
//        
//        if (control.selectedSegmentIndex == 0) {
//            self.collectionView.hidden = YES;
//            self.collectionView.alpha = 0.0;
//            
//            self.tableView.hidden = NO;
//            self.tableView.alpha = 1.0;
//            [self.tableView reloadData];
//        }else{
//            self.tableView.hidden = YES;
//            self.tableView.alpha = 0.0;
//            
//            self.collectionView.hidden = NO;
//            self.collectionView.alpha = 1.0;
//            [self.collectionView reloadData];
//        }
//    }];
//    
//}
//
- (void)showProductDetailView:(NSUInteger)index
{
    ProductDetailViewController *productDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    productDetailVC.product = (Product*)[self.childProducts objectAtIndex:index];
    productDetailVC.productVCReference = self;
    
    productDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.childProducts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionTextCell *productSectionCell = (SectionTextCell*)[tableView dequeueReusableCellWithIdentifier:@"ProductSectionCell"];
    
    Product *product = [self.childProducts objectAtIndex:indexPath.section];
    
    NSLog(@"%@",product.name);
    
    productSectionCell.sectionNameLabel.text = product.name;

    productSectionCell.topicImageView.layer.borderColor = [UIColor blackColor].CGColor;
    productSectionCell.topicImageView.layer.borderWidth = 1.0;
    
    if (product.images.count > 0){
        ImageProduct *imageProduct = [product mainImageProduct];
        [imageProduct imageInView:productSectionCell.topicImageView onSuccess:^(UIImage *image, BOOL isNew) {
            [productSectionCell.topicImageView setImage:image];
        } onError:nil];
    }
    
    return productSectionCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showProductDetailView:indexPath.section];
}

#pragma mark - Private

-(void)setupCustomBackButton
{
    //setting up new button on left
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.titleLabel.font = [UIFont fontWithName:button.titleLabel.font.fontName size:16.0];
    
    NSString *title = @"Voltar";
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(didTouchBackBtn:) forControlEvents:UIControlEventTouchUpInside]; //adding action
    //[button setBackgroundImage:[UIImage imageNamed:@"custom_back_button.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"custom_back_button_selected.png"] forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, 33);
    
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


@end
