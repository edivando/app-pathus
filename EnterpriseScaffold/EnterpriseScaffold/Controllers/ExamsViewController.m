//
//  ExamsViewController.m
//  PetProject
//
//  Created by Lucas Torquato on 2/15/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "ExamsViewController.h"
#import "ExamCell.h"
#import "Exam.h"

#import "ExamClient.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "MWPhotoBrowser.h"
#import "ReaderViewController.h"
#import "ADPopupView.h"
#import "LoginViewController.h"

#import "UserClient.h"
#import "DesignConfig.h"

#import "FilterExamsViewController.h"
#import "ExamsHeaderPatientNameViewController.h"

#import "NSString+Utility.h"
#import "NSDate+Utility.h"

#import <QuartzCore/QuartzCore.h>

@interface ExamsViewController () <MWPhotoBrowserDelegate, ReaderViewControllerDelegate, ADPopupViewDelegate, FilterExamsDelegate>

// General
@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSArray *exams;
@property (nonatomic, strong) Exam *examSelected;
@property (nonatomic, strong) ADPopupView *visiblePopup;

@property (nonatomic, strong) UIActivityViewController *activityViewController;

// Filter Attr
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDate *startdate;
@property (nonatomic, strong) NSDate *enddate;

@property (nonatomic, strong) NSDictionary *examsByPatient;

@end

@implementation ExamsViewController

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
    
    self.title = @"Exames";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //drawing shadow for footer
    self.footerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.footerView.layer.shadowOpacity = 0.4f;
    self.footerView.layer.shadowOffset = CGSizeMake(5.0f, -1.0f);
    self.footerView.layer.shadowRadius = 3.0f;
    self.footerView.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.footerView.bounds];
    self.footerView.layer.shadowPath = path.CGPath;
    self.logoutBtn.layer.borderColor = self.logoutBtn.titleLabel.textColor.CGColor;
    self.logoutBtn.layer.borderWidth = 1.0f;
    
    [self getAllExamsRequest];
    
    if ([[User sharedUser] userType] == UserTypePatient) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.user = [User sharedUser];
    self.usernameLabel.text = [self.user name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filter Exams Delegate

- (void)filterExamsByUsername:(NSString *)username startdate:(NSDate *)startdate enddate:(NSDate *)enddate
{
    self.username = username;
    self.startdate = startdate;
    self.enddate = enddate;
    
    if ((startdate == nil || [startdate isEqual:@""]) && (enddate == nil || [enddate isEqual:@""]) ) {
        
        self.examsByPatient = [username isNilOrEmpty] ? [Exam getAllByPatientName] : [Exam getContainsPatientName:username];
        
    }else if([username isNilOrEmpty]){
        self.examsByPatient = [Exam getWithStartDate:startdate eneDate:enddate];
        
    }else{
        self.examsByPatient = [Exam getContainsPatientName:username startDate:startdate eneDate:enddate];
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchLogoutBtn:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Encerrar Sessão" message:@"Você tem certeza?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (IBAction)didTouchFilterBtn:(id)sender
{
    [self performSegueWithIdentifier:@"showFilterVC" sender:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFilterVC"]) {
        FilterExamsViewController *filterVC = [[[segue destinationViewController] viewControllers] firstObject];
        filterVC.delegate = self;
        filterVC.username = [self.username copy];
        filterVC.startdate = [self.startdate copy];
        filterVC.enddate = [self.enddate copy];
    }
}

#pragma mark - Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        [User logout];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Requests

- (void)getAllExamsRequest
{
    [SVProgressHUD showWithStatus:@"Carregando..." maskType:SVProgressHUDMaskTypeBlack];
    [[ExamClient sharedInstance] allWithUserID:[User userIdentifier] onSuccess:^(NSArray *exams) {
        
        [SVProgressHUD dismiss];
        [Exam synchronize:exams];
    
        if ([[User sharedUser] userType] == UserTypePatient) {
            self.exams = [Exam getAllOrderByDate];
        }else{
            self.examsByPatient = [Exam getAllByPatientName];
        }
        
        [self.tableView reloadData];
        
        [self checkForBlankState];
        
    } onError:^(NSError *error) {
        
        // Renew Token
        if (error.code == 555) {
            [self getAllExamsRequest];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Error ao atualizar as informações..."];
        }
        
    }];
}

#pragma mark - TableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[User sharedUser] userType] == UserTypePatient) {
        return self.exams.count;
    }else{
        return self.examsByPatient.allKeys.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[User sharedUser] userType] == UserTypePatient) {
        return 1;
    }else{
        
        NSString *key = self.examsByPatient.allKeys[section];
        return [self.examsByPatient[key] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCell" forIndexPath:indexPath];

    Exam *exam = nil;
    if ([[User sharedUser] userType] == UserTypePatient) {
        exam = [self.exams objectAtIndex:indexPath.section];
    }else{
        NSString *key = self.examsByPatient.allKeys[indexPath.section];
        exam = self.examsByPatient[key][indexPath.row];
    }
    
    cell.nameLabel.text = exam.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"realizado em %@",[exam.date formatToStr]];
    
    cell.exam = exam;
    cell.examsDelegate = self;
    
    // Disable OBSbtn when no exist observation
    if ([exam.observation isEqualToString:@""] || exam.observation == nil) {
        cell.obsBtn.enabled = NO;
        cell.obsBtn.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *patientName = self.examsByPatient.allKeys[section];
    
    ExamsHeaderPatientNameViewController *header = [self.storyboard instantiateViewControllerWithIdentifier:@"ExamsHeaderPatientNameViewController"];
    header.titleValue = (self.startdate == nil) ? patientName : [NSString stringWithFormat:@" %@ em %@ ~ %@", patientName, [self.startdate formatToBRStr], [self.enddate formatToBRStr]];
    header.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0);
    
    return header.view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

#pragma mark - Exams Delegate

- (void)showExamDetail:(Exam*)exam
{
    self.examSelected = exam;
    
    if ([exam isPDFFile]) {
        [self showExamPDF:exam];
    }else{
        [self showExamIMG:exam];
    }
}

- (void)showExamObs:(ExamCell *)examCell
{
    if (examCell.obsBtn.selected) {
        
        ExamCell *lastTouchCell = (ExamCell*)self.visiblePopup.parentCell;
        
        // Deselect ObsBtn when user taps on a different cell
        if (examCell != lastTouchCell) {
            
            lastTouchCell.obsBtn.selected = NO;
            if (self.visiblePopup) {
                [self.visiblePopup removeFromSuperview];
                [self setVisiblePopup:nil];
            }
        }
    
        [self addVisiblePopupInCell:examCell];
 
    }else{
        
        [self.visiblePopup removeFromSuperview];
        [self setVisiblePopup:nil];
    }
    
}

- (void)addVisiblePopupInCell:(ExamCell*)examCell
{
    CGPoint point = CGPointMake(
                                examCell.frame.origin.x + examCell.obsBtn.frame.origin.x
                                , examCell.frame.origin.y + examCell.obsBtn.frame.origin.y + 10);
    
    NSString *message = [[examCell.exam.observation componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    
    self.visiblePopup = [[ADPopupView alloc] initAtPoint:point delegate:self withMessage:message];
    
    self.visiblePopup.popupColor = [UIColor darkGrayColor];
    [self.visiblePopup showInView:self.tableView withCell:examCell animated:YES];
}

#pragma mark - auxiliary methods

- (void)checkForBlankState
{
    if ([[User sharedUser] userType] == UserTypePatient) {
        self.noExamsLabel.hidden = (self.exams.count > 0);
    }else{
        self.noExamsLabel.hidden = (self.examsByPatient.count > 0);
    }
}


#pragma mark - Show Exam

#pragma mark PDF

- (void)loadPDFView:(Exam*)exam
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[exam fileSystemPath] password:nil];
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    
    [readerViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePDFExam)]];
    
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    readerViewController.delegate = self;
//    [self.navigationController pushViewController:readerViewController animated:YES];
    
    [self presentViewController:readerViewController animated:YES completion:nil];
}

- (void)sharePDFExam
{
    NSMutableArray *itens = [NSMutableArray new];
    
    NSString *text = [NSString stringWithFormat:@"Exame: %@ \n Animal: %@ \n Médico: %@",self.examSelected.name, self.examSelected.petName, self.examSelected.doctorName];
    [itens addObject:text];
    
    // Atach Exam PDF File
    NSData *pdfData = [NSData dataWithContentsOfFile:[self.examSelected fileSystemPath]];
    [itens addObject:pdfData];
    //
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itens applicationActivities:nil];
    self.activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

- (void)showExamPDF:(Exam*)exam
{
    if ([[exam isPersisted] boolValue]) {

        [self loadPDFView:exam];
        
    }else{
        [[ExamClient sharedInstance] downloadPDFExam:exam onSuccess:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            // Show
            [self loadPDFView:exam];
            
            // Save
            [exam setIsPersisted:@YES];
            NSError *error;
            [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
            
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Não foi possível carregar."];
        }];
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark IMG

- (void)showExamIMG:(Exam*)exam
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    
    [browser setCurrentPhotoIndex:1];
    
    [self.navigationController pushViewController:browser animated:YES];
    
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [MWPhoto photoWithURL:[NSURL URLWithString:self.examSelected.fileURL]];
}


@end
