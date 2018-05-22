//
//  PhotoDetailViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Eduardo  Chaves Frota on 15/11/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController


@property (weak, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) NSArray *images;

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
- (IBAction)backButtonDidTouch:(id)sender;
@end
