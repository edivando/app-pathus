//
//  NewsImagesCell.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/18/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "NewsImagesCell.h"
#import "Post.h"
#import "ImagePost.h"
#import "NewsDetailViewController.h"
#import "VideoPlayerViewController.h"

#define BANNER_WIDTH 280
#define BANNER_HEIGHT 175

@implementation NewsImagesCell

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

#pragma mark - Action

- (void)playVideo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.videoPlayerViewController = [storyboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    self.videoPlayerViewController.videoURLString = self.post.videoURL;
    
    [self.newsVCReference presentViewController:self.videoPlayerViewController animated:YES completion:nil];
}

#pragma mark - Tap Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tapPoint = [touch locationInView:self.playIcon];
    
    if([self.playIcon pointInside:tapPoint withEvent:nil]){
        [self playVideo];
    }
    
    return NO;
}

#pragma mark - Image Scroll

- (void)loadImagesScrollView
{
    self.imgScrollView.canCancelContentTouches = NO;
    self.imgScrollView.exclusiveTouch = NO;
    
    int i = 0;
    if (![self.post.videoURL isEqualToString:@""] && ![self.post.videoImageCoverURL isEqualToString:@""]) {
        
        self.videoImageView = [[UIImageView alloc] init];
        [self.videoImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        NSURL *url = [NSURL URLWithString:self.post.videoImageCoverURL];
        
        //__block UIImageView *imgView = self.videoImageView;
        //__block UIImageView *playBlock = self.playIcon;
        
        
        __weak NewsImagesCell *weakSelf = self;
        
        [self.videoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            weakSelf.playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play-icon.png"]];
            weakSelf.playIcon.userInteractionEnabled = YES;
            [weakSelf.playIcon setFrame:CGRectMake(110, 58, 60, 60)];
            
            [weakSelf.videoImageView setImage:image];
            [weakSelf.videoImageView addSubview:weakSelf.playIcon];
            
            [weakSelf addImageView:weakSelf.videoImageView inHeaderScroolOrder:i];
            
            // Tap Gesture
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(playVideo:)];
            tapRecognizer.numberOfTapsRequired = 1;
            tapRecognizer.delegate = weakSelf;
            [weakSelf.playIcon addGestureRecognizer:tapRecognizer];
            
        } failure:nil];
        
        i++;
    }
    
    for (ImagePost *imgPost in self.post.images.allObjects) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imgPost imageInView:imageView onSuccess:^(UIImage *image, BOOL isNew) {
            [imageView setImage:image];
            [self addImageView:imageView inHeaderScroolOrder:i];
        } onError:nil];
        i++;
    }
    
    [self finishBuildImagesScrollView];
}

- (void)addImageView:(UIImageView*)imageView inHeaderScroolOrder:(int)order
{
    imageView.frame = CGRectMake((order)*BANNER_WIDTH, 0, BANNER_WIDTH, BANNER_HEIGHT);
    [self.imgScrollView addSubview:imageView];
}

- (void)finishBuildImagesScrollView
{
    self.imgScrollView.pagingEnabled = YES;
    self.imgScrollView.scrollEnabled = YES;
    
    if (![self.post.videoURL isEqualToString:@""]) {
        self.pageControl.numberOfPages = self.post.images.allObjects.count + 1;
    }else{
        self.pageControl.numberOfPages = self.post.images.allObjects.count;
    }
    
    self.pageControl.currentPage = 0;
}

#pragma mark - Scroll Delegate and Page Control

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"%d",page);
    self.pageControl.currentPage = page;
}

- (IBAction)clickPageControl:(id) sender
{
    NSInteger page = self.pageControl.currentPage;
    
    CGRect frame = self.imgScrollView.frame;
    
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [self.imgScrollView scrollRectToVisible:frame animated:YES];
}

@end
