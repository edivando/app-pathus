//
//  ExamCell.h
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Exam, ExamCell;

@protocol ExamsDelegate <NSObject>

- (void)showExamDetail:(Exam*)exam;
- (void)showExamObs:(ExamCell*)examCell;

@end

@interface ExamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *docNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *obsBtn;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;

@property (strong, nonatomic) Exam *exam;
@property (weak, nonatomic) id<ExamsDelegate> examsDelegate;

- (IBAction)didTouchObsBtn:(id)sender;
- (IBAction)didTouchExamBtn:(id)sender;

@end
