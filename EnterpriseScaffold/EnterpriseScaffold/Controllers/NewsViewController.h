//
//  NewsViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *blankStateLabel;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchBackBtn:(id)sender;

@end
