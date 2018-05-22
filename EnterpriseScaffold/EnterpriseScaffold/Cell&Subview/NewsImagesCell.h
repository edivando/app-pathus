//
//  NewsImagesCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/18/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post, NewsDetailViewController, VideoPlayerViewController;

@interface NewsImagesCell : UITableViewCell <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) Post *post;

@property (nonatomic, strong) VideoPlayerViewController *videoPlayerViewController;
@property (nonatomic, weak) NewsDetailViewController *newsVCReference;

- (void)loadImagesScrollView;

@end
