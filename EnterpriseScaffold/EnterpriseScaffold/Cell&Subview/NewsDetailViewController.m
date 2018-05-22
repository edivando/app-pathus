//
//  NewsDetailViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 10/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Post.h"
#import <QuartzCore/QuartzCore.h>
#import "NewsViewController.h"
#import "NewsTitleCell.h"
#import "NewsImagesCell.h"
#import "NewsTextCell.h"

#define BANNER_WIDTH 280
#define BANNER_HEIGHT 175

#define TEXT_FIXED_OFFSET 80

typedef NS_ENUM(NSInteger, StoryTransitionType)
{
    StoryTransitionTypeNext,
    StoryTransitionTypePrevious
};

@interface NewsDetailViewController ()

@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (nonatomic, assign) BOOL haveImage;

@property (nonatomic, strong) NSArray *rowHeights;
@property (nonatomic, strong) UIFont *textFont;


@end

@implementation NewsDetailViewController

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
    
    // Set Font
    self.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    
    // Set Delegate TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Enable or not UP/DOWN button
    self.upBtn.enabled = (self.postUP) ? YES : NO;
    self.upBtn.alpha = self.upBtn.enabled + 0.7;
    self.downBtn.enabled = (self.postDOWN) ? YES : NO;
    self.downBtn.alpha = self.downBtn.enabled + 0.7;    

    //drawing shadow for footer
    self.footerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.footerView.layer.shadowOpacity = 0.4f;
    self.footerView.layer.shadowOffset = CGSizeMake(5.0f, -1.0f);
    self.footerView.layer.shadowRadius = 3.0f;
    self.footerView.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.footerView.bounds];
    self.footerView.layer.shadowPath = path.CGPath;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchUpBtn:(id)sender {
    [self transitionToStory:StoryTransitionTypePrevious];
}

- (IBAction)didTouchDownBtn:(id)sender {
    [self transitionToStory:StoryTransitionTypeNext];
}

- (IBAction)didTouchShareBtn:(id)sender
{
    NSString *text = [NSString stringWithFormat:@"%@ \n\n %@",self.post.title, self.post.descriptionText];
    
    NSMutableArray *itens = [NSMutableArray new];
    [itens addObject:text];
    if (self.post.images.count > 0) {
        [itens addObject:self.post.images.allObjects.lastObject];
    }
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itens applicationActivities:nil];
    self.activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 2;
    
    if (self.post.images.count > 0 || (![self.post.videoURL isEqualToString:@""] && ![self.post.videoImageCoverURL isEqualToString:@""])) {
        rows++;
        self.haveImage = YES;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        return [self createTitleCellForTable:tableView withIndexPath:indexPath];
    }else if (row == 1 && self.haveImage){
        return [self createImagesCellForTable:tableView withIndexPath:indexPath];
    }
    
    return [self createTextCelllForTable:tableView withIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rowHeights)
    {
        // Text Height
        NSUInteger totalHeight = [self heightfTextForText:self.post.body];
        self.rowHeights = (self.haveImage) ? @[@(105),@(200) ,@(totalHeight)] : @[@(105), @(totalHeight)];
    }
    
    return [self.rowHeights[indexPath.row] floatValue];
}


#pragma mark - Dynamic Row Heights

- (CGFloat)heightfTextForText:(NSString*)text
{

    NSString *textToMeasure = text;
    if ([textToMeasure hasSuffix:@"\n"])
    {
        textToMeasure = [NSString stringWithFormat:@"%@-", text];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName: self.textFont, NSParagraphStyleAttributeName : paragraphStyle };
    
    CGFloat textViewEdgeInsetApproximation = (text.length - 776.0)*0.0270;
    
    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    CGFloat textOffset = TEXT_FIXED_OFFSET + textViewEdgeInsetApproximation;
    CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + textOffset);
    return measuredHeight;
    
}

#pragma mark - Load Cell

- (NewsTitleCell*)createTitleCellForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    NewsTitleCell *newsTitleCell = (NewsTitleCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsTitleCell" forIndexPath:indexPath];
    newsTitleCell.titleLabel.text =  self.post.title;;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    newsTitleCell.dateLabel.text = [dateFormatter stringFromDate:self.post.date];
    
    [newsTitleCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return newsTitleCell;
}

- (NewsImagesCell*)createImagesCellForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    NewsImagesCell *newsImagesCell = (NewsImagesCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsImagesCell" forIndexPath:indexPath];

    // Remove All Subviews from ImgScroll
    [[newsImagesCell.imgScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Config Image Scroll
    newsImagesCell.imgScrollView.delegate = newsImagesCell;
    newsImagesCell.imgScrollView.pagingEnabled = NO;
    newsImagesCell.imgScrollView.scrollEnabled = NO;
    
    // Set Content Size
    if (![self.post.videoURL isEqualToString:@""] && ![self.post.videoImageCoverURL isEqualToString:@""]) {
        newsImagesCell.imgScrollView.contentSize = CGSizeMake((self.post.images.count + 1)*BANNER_WIDTH, BANNER_HEIGHT);
    }else{
        newsImagesCell.imgScrollView.contentSize = CGSizeMake(self.post.images.count*BANNER_WIDTH, BANNER_HEIGHT);
    }
    
    // Set references
    newsImagesCell.post = self.post;
    newsImagesCell.newsVCReference = self;
    
    // Load
    [newsImagesCell loadImagesScrollView];
    
    [newsImagesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return newsImagesCell;
}

- (NewsTextCell*)createTextCelllForTable:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath
{
    NewsTextCell *newsTextCell = (NewsTextCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsTextCell" forIndexPath:indexPath];
    
    newsTextCell.textString = self.post.body;

    [newsTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return newsTextCell;
}

#pragma mark - Transiction 

- (void)transitionToStory:(StoryTransitionType)transitionType
{
    CABasicAnimation *stretchAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [stretchAnimation setToValue:[NSNumber numberWithFloat:1.02]];
    [stretchAnimation setRemovedOnCompletion:YES];
    [stretchAnimation setFillMode:kCAFillModeRemoved];
    [stretchAnimation setAutoreverses:YES];
    [stretchAnimation setDuration:0.15];
    [stretchAnimation setDelegate:self];

    [stretchAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self setAnchorPoint:CGPointMake(0.0, (transitionType==StoryTransitionTypeNext)?1:0) forView:self.view];
    [self.view.layer addAnimation:stretchAnimation forKey:@"stretchAnimation"];
   
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:(transitionType == StoryTransitionTypeNext ? kCATransitionFromTop : kCATransitionFromBottom)];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:nil];

    if (transitionType == StoryTransitionTypePrevious) {
        self.rowSelected--;
        self.post = self.postUP;
        
        self.postDOWN = (self.rowSelected + 2 <= self.news.count) ? [self.news objectAtIndex:self.rowSelected + 1] : nil;
        self.postUP = (self.rowSelected - 1 != -1) ? [self.news objectAtIndex:self.rowSelected -1] : nil;
        
    }else{
        self.rowSelected++;
        self.post = self.postDOWN;
        
        self.postDOWN = (self.rowSelected + 2 <= self.news.count) ? [self.news objectAtIndex:self.rowSelected + 1] : nil;
        self.postUP = (self.rowSelected - 1 != -1) ? [self.news objectAtIndex:self.rowSelected -1] : nil;
    }
    
    [self showNew];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - Layout

- (void)showNew
{
    // Reset Data
    self.haveImage = NO;
    [self setRowHeights:nil];
    
    // Reload Table
    [self.tableView reloadData];
    
    // Enable or not UP button
    self.upBtn.enabled = (self.postUP) ? YES : NO;
    self.upBtn.alpha = self.upBtn.enabled + 0.7;
    // Enable or not DOWN button
    self.downBtn.enabled = (self.postDOWN) ? YES : NO;
    self.downBtn.alpha = self.downBtn.enabled + 0.7;
    
    //scroll to the top
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

@end
