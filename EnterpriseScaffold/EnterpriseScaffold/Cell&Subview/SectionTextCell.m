//
//  SectionTextCell.m
//  BelezaFashion
//
//  Created by Lucas Eduardo  Chaves Frota on 23/11/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "SectionTextCell.h"
#import "DesignConfig.h"
#import <QuartzCore/QuartzCore.h>


@interface SectionTextCell ()
{
    UIColor *_originalColor;
}
@end

@implementation SectionTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//    if (!_originalColor) {
//        _originalColor = self.disclosureIndicator.backgroundColor;
//    }
//    
//    self.sectionNameLabel.highlightedTextColor = SECTION_TEXT_SELECTED_COLOR;
//    
//    if (selected) {
//        self.disclosureIndicator.backgroundColor = SECTION_TEXT_SELECTED_COLOR;
//        self.separatorLine.backgroundColor = SECTION_TEXT_SELECTED_COLOR;
//    } else {
//        self.disclosureIndicator.backgroundColor = _originalColor;
//        self.separatorLine.backgroundColor = _originalColor;
//    }
}

-(void)loadSelectedBackgroud
{
//    self.disclosureIndicator.layer.cornerRadius = 7.5;
//    self.disclosureIndicator.layer.masksToBounds = YES;
//    
//    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.selectedBackgroundView.backgroundColor = SECTION_SELECTED_COLOR;
//    self.selectedBackgroundView.opaque = NO;
}

@end
