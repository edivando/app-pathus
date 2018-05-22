//
//  VideoPlayerViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/4/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


#import "VideoPlayerViewController.h"
#import "SVProgressHUD.h"

@implementation VideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backBtn.alpha = 0;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    self.videoPlayer = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:self.videoURLString] quality:LBYouTubeVideoQualityLarge];
    self.videoPlayer.delegate = self;
    self.videoPlayer.view.frame = CGRectMake(0, 0, 315.0f, 400.0f);
    self.videoPlayer.view.center = self.view.center;
    
    [self.view addSubview:self.videoPlayer.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFirstTime) {
        [self didTouchInsideBackBtn:nil];
    }
    self.isFirstTime = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

#pragma mark - Notification

- (void)playerWillExitFullscreen:(NSNotification *)notification
{
    [self didTouchInsideBackBtn:nil];
}

#pragma mark - Actions

- (IBAction)didTouchInsideBackBtn:(id)sender
{
    [self.videoPlayer stop];
    [self setVideoPlayer:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Video Delegate

- (void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    [SVProgressHUD dismiss];
    [self.videoPlayer setFullscreen:YES animated:YES];
}

- (void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    self.backBtn.alpha = 1;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Ocorreu algum erro inesperado =("];
}

@end
