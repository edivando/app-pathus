//
//  ContactViewController.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 12/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UILabel *blankStateLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateCurrent;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)didTouchBackBtn:(id)sender;

- (IBAction)didTouchRouteBtn:(id)sender;
- (IBAction)didTouchCallbtn:(id)sender;
- (IBAction)didTouchEmailBtn:(id)sender;

@end
