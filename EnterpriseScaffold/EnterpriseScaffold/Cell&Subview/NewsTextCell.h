//
//  NewsTextCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/18/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTextCell : UITableViewCell

@property (strong, nonatomic) NSString *textString;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@end
