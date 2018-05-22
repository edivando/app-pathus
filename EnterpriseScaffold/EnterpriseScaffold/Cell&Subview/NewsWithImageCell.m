//
//  NewsWithImageCell.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "NewsWithImageCell.h"
#import "DesignConfig.h"

@implementation NewsWithImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.dateLabel.highlightedTextColor = self.dateLabel.textColor;
    self.titleLabel.highlightedTextColor = self.titleLabel.textColor;
}

-(void)loadSelectedBackgroud
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView.backgroundColor = NEWS_SELECTION_COLOR;
    self.selectedBackgroundView.opaque = NO;
}

@end
