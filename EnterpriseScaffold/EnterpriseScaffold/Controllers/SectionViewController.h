//
//  SectionViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 27/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


#import "EnterpriseConfig.h"

@class Section;

@interface SectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *blankStateLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) Section *section;

@property (assign, nonatomic) BOOL isSubsection;


- (IBAction)didTouchBackBtn:(id)sender;

@end
