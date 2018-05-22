//
//  TopEnterInfoViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "TopEnterInfoViewController.h"
#import "EnterpriseInfoViewController.h"

@interface TopEnterInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * imageView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;

@end

@implementation TopEnterInfoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Public
//
//- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
//    
//    M6ParallaxController * parallaxController = [self parallaxController];
//    
//    if (newHeight >= parallaxController.topViewControllerStandartHeight) {
//        
//        [self.imageView setAlpha:1];
//        [self.label1 setAlpha:1];
//        [self.label2 setAlpha:1];
//        [self.label3 setAlpha:1];
//        
//        float r = (parallaxController.topViewControllerStandartHeight * 1.25f) / newHeight;
//        
//        [self.gradientImageView setAlpha:r*r];
//        
//    } else {
//        
//        float r = newHeight / parallaxController.topViewControllerStandartHeight;
//        [self.imageView setAlpha:r];
//        [self.label1 setAlpha:r];
//        [self.label2 setAlpha:r*r];
//        [self.label3 setAlpha:r*r*r*r];
//        [self.gradientImageView setAlpha:r*r*r*r];
//        
//    }
//    
//}
//
//- (IBAction)didTouchBackBtn:(id)sender
//{
//    [self.parallaxController dismissViewControllerAnimated:YES completion:nil];
//}

@end
