//
//  ProductsViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 30/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


@class Section;

@interface ProductsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeBtn;

@property (nonatomic, strong) Section *section;
@property (assign, nonatomic) BOOL isMaster;

@property (assign, nonatomic) BOOL isCollectionMode;

- (IBAction)didTouchBackBtn:(id)sender;
//- (IBAction)didTouchViewTypeBtn:(id)sender;

@end
