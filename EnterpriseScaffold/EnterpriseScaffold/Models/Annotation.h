//
//  Annotation.h
//  EnterpriseScaffold
//
//  Created by Lucas Torquato on 12/10/13.
//  Copyright (c) 2013 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
