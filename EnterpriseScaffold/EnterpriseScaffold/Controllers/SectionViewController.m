//
//  SectionViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 27/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "SectionViewController.h"
#import "SectionTextCell.h"
#import "Section.h"
#import "SectionClient.h"
#import "ProductsViewController.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "AppDelegate.h"

#import "AFNetworking.h"

@interface SectionViewController ()

@property (nonatomic, strong) NSArray *childSections;

@end

@implementation SectionViewController

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
    
    if (self.isSubsection) {
        self.title = self.section.name;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchBackBtn:)];
    }else{
        self.section = [Section secondMasterSection];
        self.title = @"Serviços";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchBackBtn:)];
    }
}


- (void)loadAllSections
{
    // Get All Sections With Products
    [[SectionClient sharedInstance] allWithEnterpriseID:[[EnterpriseConfig sharedInstance] iD] onSuccess:^(NSArray *sections) {
        
        self.childSections = sections;
//        [SVProgressHUD dismiss];
//        // Send token request - anonymous
//        if([User pushToken] == nil || [[User pushToken] isEqualToString:@""]){
//            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            appDelegate.pushDelegate = self;
//            [AppDelegate enablePushService];
//        }
        
    } onError:^(NSError *error) {
        
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"Erro ao tentar atualizar as sessões..."];
        NSLog(@"FALIED");
        
    }];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAllSections];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!self.childSections) {
        // Get Child Itens order by Priority
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.childSections = [self.section.sections.allObjects sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    if (self.childSections.count == 0) {
        self.blankStateLabel.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.blankStateLabel.hidden = YES;
        self.tableView.hidden = NO;
    }
}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    if (self.isSubsection) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.childSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionTextCell *sectionCell = (SectionTextCell*)[tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
    
    Section *section = [self.childSections objectAtIndex:indexPath.section];
    
    NSLog(@"%@",section.name);
    
    sectionCell.sectionNameLabel.text = section.name;
    
    sectionCell.topicImageView.layer.borderColor = [UIColor blackColor].CGColor;
    sectionCell.topicImageView.layer.borderWidth = 1.0;
    
    [section imageInView:sectionCell.topicImageView onSuccess:^(UIImage *image, BOOL isNew) {
        [sectionCell.topicImageView setImage:image];
    } onError:nil];
    
    //[sectionCell loadSelectedBackgroud];
    

    return sectionCell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section *sectionSelected = [self.childSections objectAtIndex:indexPath.section];
    
    if (sectionSelected.sections.count > 0) {
        // SECTIONS VIEW
        SectionViewController *sectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionViewController"];
        sectionVC.section = sectionSelected;
        sectionVC.isSubsection = YES;
        [self.navigationController pushViewController:sectionVC animated:YES];
        
    }else{
        // PRODUCTS VIEW
        ProductsViewController *productsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsViewController"];
        productsVC.section = sectionSelected;
        [self.navigationController pushViewController:productsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
}
*/


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
