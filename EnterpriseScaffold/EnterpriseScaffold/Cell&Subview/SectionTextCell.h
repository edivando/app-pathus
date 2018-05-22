//
//  SectionTextCell.h
//  BelezaFashion
//
//  Created by Lucas Eduardo  Chaves Frota on 23/11/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureIndicator;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

-(void)loadSelectedBackgroud;

@end
