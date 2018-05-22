//
//  EnterpriseTableViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 07/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "EnterpriseTableViewController.h"
#import "M6ParallaxController.h"
#import "TextEnterCell.h"
#import "Enterprise.h"
#import "VideoEnterCell.h"
#import "AFNetworking.h"
#import "PhotoDetailViewController.h"


#import <QuartzCore/QuartzCore.h>

#define SEPARATOR_CELL 0
#define TEXT_CELL_ONE 1
#define IMAGES_CELL 2
#define TEXT_CELL_TWO 3
#define VIDEO_CELL 4

#define TEXT_OFFSET 30

@interface EnterpriseTableViewController ()

@property (nonatomic, strong) Enterprise *enterprise;
@property (nonatomic, strong) NSArray *rowHeights;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSArray *enterpriseImages;

@property (nonatomic, strong) CALayer *tappedImageSubLayer;
@property (nonatomic, strong) UIImage *tappedImage;
@property (nonatomic, strong) UIColor *originalBackgroundColor;

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation EnterpriseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    // Enterprise Instance
    self.enterprise = [Enterprise instance];
    self.enterpriseImages = self.enterprise.images.allObjects;
    
    self.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.parallaxController tableViewControllerDidScroll:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 4; // separator, First/Second Description and Images
    
    if (![self.enterprise.videoURL isEqualToString:@""] && ![self.enterprise.videoImageCoverURL isEqualToString:@""]) {
        rows++;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
  //  SeparatorCellID
    if (row == SEPARATOR_CELL) {
        return [self createSeparateCellForTable:tableView withIndexPath:indexPath];
    }else if (row == TEXT_CELL_ONE) {
        return [self createTextEnterCellForTable:tableView withIndexPath:indexPath text:self.enterprise.firstDescription];
    }else if (row == IMAGES_CELL){
        return [self createImagesEnterCellForTable:tableView withIndexPath:indexPath];
    }else if (row == TEXT_CELL_TWO){
        return [self createTextEnterCellForTable:tableView withIndexPath:indexPath text:self.enterprise.secondDescription];
    }else if (row == VIDEO_CELL){
        return [self createVideoEnterCelllForTable:tableView withIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rowHeights)
    {    
        NSUInteger firstTextHeight = [self heightfTextForText:self.enterprise.firstDescription];
        NSUInteger secondTextHeight = [self heightfTextForText:self.enterprise.secondDescription];
        
        self.rowHeights = @[@(10), @(firstTextHeight + TEXT_OFFSET), @(200), @(secondTextHeight + TEXT_OFFSET), @(200)];
    }
    
    return [self.rowHeights[indexPath.row] floatValue];
}

#pragma mark - Dynamic Row Heights

-(CGFloat)heightfTextForText:(NSString*)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 1000)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:self.textFont}
                                                                context:nil];
    
    return textRect.size.height;
}


#pragma mark - Load Cell

- (UITableViewCell*)createSeparateCellForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *separatorCell = [tableView dequeueReusableCellWithIdentifier:@"SeparatorCellID" forIndexPath:indexPath];
    separatorCell.backgroundColor = [UIColor whiteColor];
    return separatorCell;
}


- (TextEnterCell*)createTextEnterCellForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath text:(NSString*)text
{
    TextEnterCell *textEnterCell = (TextEnterCell*)[tableView dequeueReusableCellWithIdentifier:@"TextEnterCell" forIndexPath:indexPath];
    textEnterCell.textView.font = self.textFont;
    textEnterCell.textString = text;
  
    return textEnterCell;
}

- (ImagesEnterCell*)createImagesEnterCellForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    ImagesEnterCell *imagesEnterCell = (ImagesEnterCell*)[tableView dequeueReusableCellWithIdentifier:@"ImagesEnterCell" forIndexPath:indexPath];
    imagesEnterCell.images = self.enterpriseImages;
    imagesEnterCell.delegate = self;
    
    return imagesEnterCell;
}

- (VideoEnterCell*)createVideoEnterCelllForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    VideoEnterCell *videoEnterCell = (VideoEnterCell*)[tableView dequeueReusableCellWithIdentifier:@"VideoEnterCell" forIndexPath:indexPath];
    videoEnterCell.enterpriseTVReference = self;
    videoEnterCell.videoURL = self.enterprise.videoURL;
    
    
    NSURL *url = [NSURL URLWithString:self.enterprise.videoImageCoverURL];
    
    [videoEnterCell.videoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [videoEnterCell.videoImageView setImage:image];
    } failure:nil];
     
    return videoEnterCell;
}


#pragma mark - Image Tap Delegate

-(void)imageViewDidTapped:(UIImageView *)imageView withRelativeFrame:(CGRect)relativeFrame
{
    self.tappedImage = imageView.image;
    
    self.originalBackgroundColor = self.view.superview.backgroundColor;
    self.view.superview.backgroundColor = [UIColor blackColor];
       

    /******** Fade out animation for the background ********/
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.view.layer addAnimation:animation forKey:nil];
    
    [self hideBackground:YES];

    
    
    /******** Creating new layer for the animated image ********/
    self.tappedImageSubLayer = [CALayer layer];
    self.tappedImageSubLayer.frame = relativeFrame;
    self.tappedImageSubLayer.contents = (id) imageView.image.CGImage;
    [self.view.superview.layer addSublayer:self.tappedImageSubLayer];

    
    
    /******** Animating new layer position and bounds to the center ********/
    
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    baseAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(self.view.superview.center.x, self.view.superview.center.y, self.tappedImageSubLayer.frame.size.width, self.tappedImageSubLayer.frame.size.height)];
    
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(self.view.superview.center.x, self.view.superview.center.y, 320, 200)]; ;
    
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.delegate = self;
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:baseAnimation, boundsAnimation, nil];
    group.duration = 0.4;
    
    //Adding animation to layer
    [self.tappedImageSubLayer addAnimation:group forKey:@"frame"];


}


-(void)hideBackground:(BOOL)mustHide
{
    for (UIView *subView in self.view.superview.subviews)
    {   
        if ([subView isKindOfClass:[UITableView class]]) {
                 subView.hidden = mustHide;
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                subView.alpha = !mustHide;
            }];
        }
    }
}

#pragma mark - Animation Delegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    PhotoDetailViewController *photoDetailController = (PhotoDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
    photoDetailController.images = self.enterpriseImages;
    photoDetailController.selectedImage = self.tappedImage;
    [photoDetailController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:photoDetailController animated:NO completion:^{
        
        self.view.superview.backgroundColor = self.originalBackgroundColor;
        [self.tappedImageSubLayer removeFromSuperlayer];
        [self hideBackground:NO];
        
    }];
    
}


@end
