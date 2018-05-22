//
//  EnterpriseInfoViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 06/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//


@interface EnterpriseInfoViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)didTouchBackBtn:(id)sender;

- (IBAction)clickPageControl:(id)sender;

@end
