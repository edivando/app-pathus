//
//  VideoEnterCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EnterpriseTableViewController, VideoPlayerViewController;

@interface VideoEnterCell : UITableViewCell

@property (weak, nonatomic) EnterpriseTableViewController *enterpriseTVReference;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic, strong) VideoPlayerViewController *videoPlayerViewController;
@property (nonatomic, strong) NSString *videoURL;

- (IBAction)didTouchPlayBtn:(id)sender;

@end
