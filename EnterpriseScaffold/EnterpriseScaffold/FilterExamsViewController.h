//
//  FilterExamsViewController.h
//  Pathus
//
//  Created by Torquato on 09/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterExamsDelegate <NSObject>

- (void)filterExamsByUsername:(NSString*)username startdate:(NSDate*)startdate enddate:(NSDate*)enddate;

@end

@interface FilterExamsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBtn;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *startdateTF;
@property (weak, nonatomic) IBOutlet UITextField *enddateTF;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDate *startdate;
@property (nonatomic, strong) NSDate *enddate;

@property (assign, nonatomic) id<FilterExamsDelegate> delegate;

- (IBAction)didTouchFilterBtn:(id)sender;
- (IBAction)didTouchBackBtn:(id)sender;

@end
