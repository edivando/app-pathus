//
//  ExamsHeaderPatientNameViewController.m
//  Pathus
//
//  Created by Torquato on 11/09/15.
//  Copyright (c) 2015 Wemob. All rights reserved.
//

#import "ExamsHeaderPatientNameViewController.h"

@interface ExamsHeaderPatientNameViewController ()

@end

@implementation ExamsHeaderPatientNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleValue;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.titleLabel.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
