//
//  VideoEnterCell.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "VideoEnterCell.h"
#import "EnterpriseTableViewController.h"
#import "VideoPlayerViewController.h"

@implementation VideoEnterCell

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

- (IBAction)didTouchPlayBtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.videoPlayerViewController = [storyboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    self.videoPlayerViewController.videoURLString = self.videoURL;

    [self.enterpriseTVReference presentViewController:self.videoPlayerViewController animated:YES completion:nil];
}

@end
