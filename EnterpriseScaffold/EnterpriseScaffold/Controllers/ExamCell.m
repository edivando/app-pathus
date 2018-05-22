//
//  ExamCell.m
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "ExamCell.h"
#import "ExamsViewController.h"
#import "DesignConfig.h"

#import "Utils.h"

@implementation ExamCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [Utils applyBorder:self.examBtn];
    
    //[self.obsBtn setBackgroundImage:[ExamCell imageWithColor:EXAM_COLOR andSize:CGSizeMake(58, 34)] forState:UIControlStateSelected];
    
//    [self.obsBtn setTintColor:EXAM_COLOR];
//    [self.obsBtn setTitleColor:EXAM_COLOR forState:UIControlStateNormal];
//    [self.obsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - Actions

- (IBAction)didTouchObsBtn:(id)sender
{
    self.obsBtn.selected = !self.obsBtn.selected;
    
    [self.examsDelegate showExamObs:self];
}

- (IBAction)didTouchExamBtn:(id)sender
{
    [self.examsDelegate showExamDetail:self.exam];
}

@end
