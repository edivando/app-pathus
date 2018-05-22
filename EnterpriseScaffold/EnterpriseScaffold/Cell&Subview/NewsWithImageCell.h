//
//  NewsWithImageCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsWithImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

-(void)loadSelectedBackgroud;

@end
