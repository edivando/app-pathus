//
//  NewsDetailViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 10/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post, NewsViewController;

@interface NewsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) NSArray *news;
@property (nonatomic, assign) NSInteger rowSelected;

@property (nonatomic, weak) Post *postUP;
@property (nonatomic, weak) Post *postDOWN;

@property (nonatomic, weak) Post *post;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, weak) NewsViewController *newsVCReference;

- (IBAction)didTouchBackBtn:(id)sender;
- (IBAction)didTouchUpBtn:(id)sender;
- (IBAction)didTouchDownBtn:(id)sender;
- (IBAction)didTouchShareBtn:(id)sender;

@end
