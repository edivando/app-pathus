//
//  ImagesEnterCell.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 11/3/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Enterprise;

@protocol ImagesTapDelegate <NSObject>

-(void)imageViewDidTapped:(UIImageView*)imageView withRelativeFrame:(CGRect)relativeFrame;

@end

@interface ImagesEnterCell : UITableViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) NSArray *images;

@property (weak, nonatomic) id<ImagesTapDelegate> delegate;

@end
