//
//  UserSearchViewController.m
//  
//
//  Created by Torquato on 11/10/15.
//
//

#import "UserSearchViewController.h"

#import "Exam.h"
#import "DesignConfig.h"

@interface UserSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *filterUsers;
@property (nonatomic, strong) NSArray *allUsers;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    self.allUsers = [Exam getAllPatients];
    self.filterUsers = [NSArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)didTouchCancelBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.filterUsers = [self.allUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[c]  %@", searchText]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = LIGHT_GREEN_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.filterUsers[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate usernameSelected:self.filterUsers[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
