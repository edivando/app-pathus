//
//  ProductSectionCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 30/09/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
