//
//  NewsTextCell.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/18/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "NewsTextCell.h"

@implementation NewsTextCell

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

    // Configure the view for the selected state
}


- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    self.bodyTextView.text = self.textString;
    
    [self.bodyTextView setFrame:CGRectMake(self.bodyTextView.frame.origin.x, self.bodyTextView.frame.origin.y, self.bodyTextView.frame.size.width, self.bodyTextView.contentSize.height)];
    
    [self.bodyTextView setScrollEnabled:NO];
    [self.bodyTextView setUserInteractionEnabled:NO];
}

@end
