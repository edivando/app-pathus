//
//  NewsCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 09/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;

-(void)loadSelectedBackgroud;

@end
