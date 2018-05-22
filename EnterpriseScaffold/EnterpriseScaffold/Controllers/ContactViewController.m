//
//  ContactViewController.m
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 12/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "ContactViewController.h"
#import "Enterprise.h"
#import "Annotation.h"
#import "SVProgressHUD.h"
#import "Store.h"

#import "StoreCell.h"

#import "NSManagedObject+Utility.h"

#import "DesignConfig.h"



#define ACTION_MAP 0
#define ACTION_CALL 1

@interface ContactViewController ()

@property (nonatomic, strong) Enterprise *enterprise;
@property (nonatomic, weak) Store *storeCurrent;

@property (nonatomic, strong) NSArray *stores;

@end

@implementation ContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:LIGHT_GREEN_COLOR];
    
    // Enterprise Instance
    self.enterprise = [Enterprise instance];
    
    // Delegate
    self.mapView.delegate = self;
    [self initGeolocation];
    
    [self addBorderAllButtons];
    
    self.stores = [Store allStoresByPriority];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addAllAnnotationsStores];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!self.enterprise) {
        self.blankStateLabel.hidden = NO;
        self.routeButton.hidden = self.emailButton.hidden = self.callButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Region
    CLLocationCoordinate2D placeCenter;
    placeCenter.latitude = [self.enterprise.latitude floatValue];
    placeCenter.longitude = [self.enterprise.longitude floatValue];
    [self updateRegion:placeCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Annotations

- (void)addAllAnnotationsStores
{
    for (Store *store in self.stores){
        
        CLLocationCoordinate2D placeCenter;
        placeCenter.latitude = [store.latitude floatValue];
        placeCenter.longitude = [store.longitude floatValue];
        
        Annotation *annotationView = [[Annotation alloc] init];
        annotationView.coordinate = placeCenter;
        annotationView.title = store.name;
        annotationView.subtitle = store.address;
        
        store.annotation = annotationView;
        
        [self.mapView addAnnotation:annotationView];
    }
    
    self.storeCurrent = self.stores.firstObject;
    [self.mapView selectAnnotation:self.storeCurrent.annotation animated:YES];
    [self.collectionView reloadData];
}


#pragma mark - Actions

- (IBAction)didTouchBackBtn:(id)sender
{
    for (Store *store in self.stores){
        store.annotation = nil;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchRouteBtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Traçar uma Rota" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps", @"Google Maps", nil];
    
    [actionSheet showInView:self.view];
}
- (IBAction)didTouchCallbtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Ligar para:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    // Add Button Title
    NSString *telephone = self.storeCurrent.telephone;
    
    if (![telephone isEqualToString:@""] && telephone != nil) {
        [actionSheet addButtonWithTitle:telephone];
    }
    
//    if (![cellphone isEqualToString:@""] && cellphone != nil) {
//        [actionSheet addButtonWithTitle:cellphone];
//    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancelar"];
    actionSheet.tag = ACTION_CALL;
    [actionSheet showInView:self.view];
}

- (IBAction)didTouchEmailBtn:(id)sender
{
    if ([MFMailComposeViewController canSendMail]){
        [self displayMailComposerSheet];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Dispositivo não está configurado para enviar e-mail."];
    }
}

#pragma mark - Collection View Delegate/DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.stores.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreCell" forIndexPath:indexPath];
    
    Store *store = self.stores[indexPath.row];
    
    if ([store.name isEqualToString:self.storeCurrent.name]) {
        cell.backgroundColor = LIGHT_GREEN_COLOR;
    }else{
        cell.backgroundColor = GREEN_COLOR;
    }
    
    cell.titleLabel.text = store.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.storeCurrent = self.stores[indexPath.row];
    
    [self.mapView setCenterCoordinate:self.storeCurrent.annotation.coordinate animated:YES];
    [self.mapView selectAnnotation:self.storeCurrent.annotation animated:YES];
}

#pragma mark - Layout

- (void)addBorderAllButtons
{
    CGColorRef borderColor = PURPLE_COLOR.CGColor;
    
    self.emailButton.layer.borderColor = borderColor;
    self.callButton.layer.borderColor = borderColor;
    self.routeButton.layer.borderColor = borderColor;
    
    CGFloat borderWidth = 1.0;
    self.emailButton.layer.borderWidth = borderWidth;
    self.callButton.layer.borderWidth = borderWidth;
    self.routeButton.layer.borderWidth = borderWidth;
}

#pragma mark - MapView Delegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        // Right - Map Route Button
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Traçar uma Rota" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps", @"Google Maps", nil];
        
        [actionSheet showInView:self.view];       
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    Annotation *annotation = (Annotation*)view.annotation;
    
    self.storeCurrent = [self.stores filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", annotation.title]].firstObject;

    NSUInteger index = [self.stores indexOfObject:self.storeCurrent];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //self.storeCurrent = nil;
}


#pragma mark - Map Aux

- (void)initGeolocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)updateRegion:(CLLocationCoordinate2D)coordinate
{
    // Alcance
    MKCoordinateSpan span;
    span.latitudeDelta = 0.13; //0.01
    span.longitudeDelta = 0.13; //0.01
    
    // Região
    MKCoordinateRegion region;
    region.span = span;
    region.center = coordinate;
    
    // Init
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    [self.mapView setMapType:MKMapTypeStandard]; // Change MapType
    
}

#pragma mark - Action Sheet Delegate - Trace Route

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_MAP) {
     
        NSString *mapsURLString;
        
        if (buttonIndex == 0) {
            mapsURLString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                             self.coordinateCurrent.latitude, self.coordinateCurrent.longitude, self.storeCurrent.latitude.floatValue, self.storeCurrent.longitude.floatValue];
        }else if (buttonIndex == 1){
            mapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                             self.coordinateCurrent.latitude, self.coordinateCurrent.longitude, self.storeCurrent.latitude.floatValue, self.storeCurrent.longitude.floatValue];
        }

        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapsURLString]];
        
        
    }else if (actionSheet.tag == ACTION_CALL){

        if(buttonIndex != actionSheet.cancelButtonIndex){
            [self callToNumber:[actionSheet buttonTitleAtIndex:buttonIndex]];
        }
        
    }
}

#pragma mark - Core Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.coordinateCurrent = newLocation.coordinate;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Mail Compose

- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
   
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Contato - Pathus APP"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:self.enterprise.email];
	
	[picker setToRecipients:toRecipients];
    
	[self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[SVProgressHUD showErrorWithStatus:@"Enviar e-mail - cancelado"];
			break;
		case MFMailComposeResultSaved:
			[SVProgressHUD showSuccessWithStatus:@"E-Mail salvo"];
			break;
		case MFMailComposeResultSent:
			[SVProgressHUD showSuccessWithStatus:@"E-Mail enviado"];
			break;
		case MFMailComposeResultFailed:
			[SVProgressHUD showErrorWithStatus:@"Enviar E-Mail - falhou"];
			break;
		default:
			[SVProgressHUD showErrorWithStatus: @"E-Mail não enviado"];
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Call

- (void)callToNumber:(NSString*)number;
{
    NSString *numberClean = [[number componentsSeparatedByCharactersInSet:
                              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                             componentsJoinedByString:@""];
    
    if([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]){
        NSString *URLString = [@"tel://" stringByAppendingString:numberClean];
        NSURL *URL = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:URL];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"O seu dispositivo não permite ligações." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
