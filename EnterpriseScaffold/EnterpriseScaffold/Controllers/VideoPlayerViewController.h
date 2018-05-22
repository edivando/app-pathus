//
//  VideoPlayerViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LBYouTube.h"

@interface VideoPlayerViewController : UIViewController <LBYouTubePlayerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSString *videoURLString;
@property (nonatomic, strong) LBYouTubePlayerController *videoPlayer;
@property (nonatomic, assign) BOOL isFirstTime;


- (IBAction)didTouchInsideBackBtn:(id)sender;

@end
