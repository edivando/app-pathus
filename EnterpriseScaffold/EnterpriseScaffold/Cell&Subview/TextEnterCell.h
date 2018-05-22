//
//  TextEnterCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEnterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *textString;

@end
