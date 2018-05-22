//
//  PhotoDetailViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Eduardo  Chaves Frota on 15/11/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ImageEnterprise.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

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
	// Do any additional setup after loading the view.
    
  }

-(void)viewDidLayoutSubviews {
    
    __block CGRect selectedRect;
    
    for (int i = 0; i < self.images.count; i++) {
        CGRect frame;
        frame.origin.x = self.imagesScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.imagesScrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];

        
        [imageView setContentMode:UIViewContentModeScaleToFill];
        
        [self.images[i] imageInView:imageView onSuccess:^(UIImage *image, BOOL isNew) {

            if (image == self.selectedImage) {
                selectedRect = imageView.frame;
            }
            
            [imageView setImage:image];
            [self.imagesScrollView addSubview:imageView];
            
        } onError:nil];
    }
    
    self.imagesScrollView.contentSize = CGSizeMake(self.imagesScrollView.frame.size.width * self.images.count, self.imagesScrollView.frame.size.height);
    [self.imagesScrollView scrollRectToVisible:selectedRect animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
