//
//  UserSearchViewController.h
//  
//
//  Created by Torquato on 11/10/15.
//
//

#import <UIKit/UIKit.h>

@protocol UserSearchDelegate <NSObject>

- (void)usernameSelected:(NSString*)username;

@end

@interface UserSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<UserSearchDelegate> delegate;

@end
