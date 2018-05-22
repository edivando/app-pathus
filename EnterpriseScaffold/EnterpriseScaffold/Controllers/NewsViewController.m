//
//  NewsViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "NewsViewController.h"
#import "PostClient.h"
#import "EnterpriseConfig.h"
#import "SVProgressHUD.h"
#import "NewsCell.h"
#import "Post.h"
#import "NewsDetailViewController.h"
#import "ImagePost.h"
#import "NewsWithImageCell.h"
#import "Enterprise.h"

#import <QuartzCore/QuartzCore.h>
#import "DesignConfig.h"

@interface NewsViewController ()

@property (nonatomic, strong) NSArray *news;

@end

@implementation NewsViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!self.news) {
        [self sendRequestForPosts];
    }else{
        [self loadPosts];
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
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

- (void)sendRequestForPosts
{
    [SVProgressHUD showWithStatus:@"Carregando..." maskType:SVProgressHUDMaskTypeBlack];
    [[PostClient sharedInstance]allWithEnterpriseID:[[EnterpriseConfig sharedInstance]iD] onSuccess:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        [Post synchronizePosts:result];
        
        [self loadPosts];
        
    } onError:^(NSError *error) {
        
        [self loadPosts];
        
        [SVProgressHUD showErrorWithStatus:@"Error ao atualizar informações..."];
    }];
}

- (void)loadPosts
{
    self.news = [Post getAllOrderByDate];
    
    if (![Enterprise instance])
    {
        self.blankStateLabel.hidden = NO;
        self.tableView.hidden = YES;
        self.blankStateLabel.text = @"Verifique sua conexão com a internet.";
    }
    else if (self.news.count == 0)
    {
        self.blankStateLabel.hidden = NO;
        self.tableView.hidden = YES;
        self.blankStateLabel.text = @"Nenhuma notícia cadastrada.";
    }
    else
    {
        self.blankStateLabel.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    [self.tableView reloadData];

}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //background
//    cell.backgroundColor = (indexPath.row % 2) == 0 ? NEWS_ZEBRA_COLOR : [UIColor whiteColor];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    Post *post = [self.news objectAtIndex:row];
    
    if (post.images.allObjects.count > 0) {
        NewsWithImageCell *newCell = (NewsWithImageCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsWithImageCell"];

        // Title
        newCell.titleLabel.text = post.title;
        
        // Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
        newCell.dateLabel.text = [dateFormatter stringFromDate:post.date];
        
        // Body
        newCell.bodyLabel.text = post.descriptionText;
    
        newCell.iconImageView.layer.cornerRadius = 5.0;
        newCell.iconImageView.layer.masksToBounds = YES;
        
        // Image
        ImagePost *imagePost = post.images.allObjects.lastObject;
        [imagePost imageInView:newCell.iconImageView onSuccess:^(UIImage *image, BOOL isNew) {
            [newCell.iconImageView setImage:image];
        } onError:nil];
        
        [newCell loadSelectedBackgroud];
        
        return newCell;
        
    }else{
        NewsCell *newCell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        
        // Title
        newCell.titleLabel.text = post.title;
        
        // Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
        newCell.dateLabel.text = [dateFormatter stringFromDate:post.date];
        
        // Body
        newCell.bodyLabel.text = post.descriptionText;
        
        [newCell loadSelectedBackgroud];
        
        return newCell;
    }
    
}

#pragma mark - UITableViewDelegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSInteger row = indexPath.row;
     Post *post = [self.news objectAtIndex:row];
     
     NewsDetailViewController *newsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
     [newsDetailVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
     
     newsDetailVC.post = post;
     newsDetailVC.postDOWN = (row + 2 <= self.news.count) ? [self.news objectAtIndex:row + 1] : nil;
     newsDetailVC.postUP = (row - 1 != -1) ? [self.news objectAtIndex:row -1] : nil;
     newsDetailVC.NewsVCReference = self;
     newsDetailVC.news = self.news;
     newsDetailVC.rowSelected = row;
     
    [self presentViewController:newsDetailVC animated:YES completion:nil];
 }

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 }
 */


 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 }
 */

@end
