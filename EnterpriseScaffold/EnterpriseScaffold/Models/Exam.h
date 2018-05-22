//
//  Exam.h
//  PetProject
//
//  Created by Lucas Torquato on 2/7/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RestKitProtocol.h"

@interface Exam : NSManagedObject <RestKitProtocol>

@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * petName;
@property (nonatomic, retain) NSString * doctorName;

@property (nonatomic, retain) NSString * observation;
@property (nonatomic, retain) NSDate * date;

@property (nonatomic, retain) NSString * fileURL;
@property (nonatomic, retain) NSString * fileType;

// PDF FILE
@property (nonatomic, retain) NSString * fileSystemPath;
@property (nonatomic, retain) NSNumber * isPersisted;

// Core Data
+ (void)synchronize:(NSArray*)examsByServer;
+ (NSArray*)getAllOrderByDate;
- (void)removePDFFile;

// Query
+ (NSDictionary*)getContainsPatientName:(NSString*)patientName;
+ (NSDictionary*)getAllByPatientName;
+ (NSArray*)getAllPatients;

+ (NSDictionary*)getWithStartDate:(NSDate*)startDate eneDate:(NSDate*)endDate;
+ (NSDictionary*)getContainsPatientName:(NSString*)patientName startDate:(NSDate*)startDate eneDate:(NSDate*)endDate;

// Aux
- (BOOL)isPDFFile;

- (NSString*)patientName;

@end
