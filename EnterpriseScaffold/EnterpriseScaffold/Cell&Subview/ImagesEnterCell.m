//
//  ImagesEnterCell.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ImagesEnterCell.h"
#import "Enterprise.h"
#import "ImageEnterprise.h"


#define BANNER_WIDTH 320
#define BANNER_HEIGHT 200

#define WIDTH 260
#define HEIGHT 180
#define PAD_INI 15
#define PAD_BE 15

@implementation ImagesEnterCell

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

- (void)layoutSubviews
{
    // Hide Page Control
    self.pageControl.alpha = 0.0;
    
    // Config Image Scroll
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = NO;
    self.imagesScrollView.scrollEnabled = NO;
    self.imagesScrollView.contentSize = CGSizeMake( PAD_INI*2 + (self.images.count*(WIDTH+PAD_BE)) , BANNER_HEIGHT);
    
    // Load View
    [self loadImagesScrollView];
}

#pragma mark - Image Scroll

- (void)loadImagesScrollView
{
    
    int i = 0;
    for (ImageEnterprise *imgEnterprise in self.images) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *detailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailView:)];
        [imageView addGestureRecognizer:detailGesture];

        [imageView setContentMode:UIViewContentModeScaleToFill];
        
        [imgEnterprise imageInView:imageView onSuccess:^(UIImage *image, BOOL isNew) {
            [imageView setImage:image];
            [self addImageView:imageView inHeaderScroolOrder:i];
        } onError:nil];
        i++;
    }
    
    [self finishBuildImagesScrollView];
}

-(void)showDetailView:(UITapGestureRecognizer*)recognizer {    
    
    UITableView *tableView = (UITableView*)self.superview.superview;
    
    UIImageView *imageView = (UIImageView*)recognizer.view ;
    CGRect relativeFrame = CGRectMake(imageView.frame.origin.x - self.imagesScrollView.contentOffset.x,
                                      self.frame.origin.y - tableView.contentOffset.y + 10,
                                      imageView.frame.size.width,
                                      imageView.frame.size.height);
    
    [self.delegate imageViewDidTapped:imageView withRelativeFrame:relativeFrame];
}


- (void)addImageView:(UIImageView*)imageView inHeaderScroolOrder:(int)order
{

    imageView.frame = CGRectMake(PAD_INI + ((order)*(WIDTH+PAD_BE))  , 10, WIDTH , HEIGHT);

    [self.imagesScrollView addSubview:imageView];
}

- (void)finishBuildImagesScrollView
{
    self.imagesScrollView.scrollEnabled = YES;
    
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
}
#pragma mark - Scroll Delegate and Page Control


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    int page = scrollView.contentOffset.x / (WIDTH);
    self.pageControl.currentPage = page;
    
    [self clickPageControl:nil];
}

- (IBAction)clickPageControl:(id) sender
{
    NSInteger page = self.pageControl.currentPage;
    
    CGRect frame = self.imagesScrollView.frame;
    
    //frame.origin.x = frame.size.width * page;
    frame.origin.x = ((page*(WIDTH+PAD_BE)) - (PAD_BE));
    frame.origin.y = 0;
    
    [self.imagesScrollView scrollRectToVisible:frame animated:YES];
}


@end
