//
//  Exam.m
//  PetProject
//
//  Created by Lucas Torquato on 2/7/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "Exam.h"

#import "NSDate+Utility.h"

@implementation Exam

@dynamic observation, date, name, fileURL, fileType, fileSystemPath, isPersisted, petName, doctorName, iD;

+ (RKObjectMapping*)mapping
{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Exam" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id" : @"iD",
                                                  @"patient_name" : @"petName",
                                                  @"doctor_name" : @"doctorName",
                                                  @"name" : @"name",
                                                  @"date" : @"date",
                                                  @"observation" : @"observation",
                                                  @"file.url" : @"fileURL",
                                                  @"file.content_type" : @"fileType"
                                                  }];
    
    mapping.identificationAttributes = @[@"iD"];
    
    return mapping;
}

+ (RKRoute*)route
{
    return [RKRoute routeWithName:@"exams" pathPattern:@"exams" method:RKRequestMethodGET];
}

#pragma mark - Core Data

+ (NSArray*)getAllOrderByDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exam" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    return [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

#pragma mark Query

+ (NSDictionary*)fetchRequestWithPredicate:(NSPredicate*)predicate
{
    //
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
    [fetchRequest setPredicate:predicate];
    NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return [Exam separateByPatient:result];
}

#pragma mark by Patiente

+ (NSPredicate*)predicateWithContainsPatientName:(NSString*)patientName
{
    return [NSPredicate predicateWithFormat:@"petName CONTAINS[cd] %@", patientName];
}

+ (NSDictionary*)getContainsPatientName:(NSString*)patientName
{
    return [Exam fetchRequestWithPredicate:[Exam predicateWithContainsPatientName:patientName]];
}

+ (NSDictionary*)getAllByPatientName
{
    NSArray *result = [Exam getAllOrderByDate];
    
    return [Exam separateByPatient:result];
}

+ (NSDictionary*)separateByPatient:(NSArray*)exams
{
    //
    NSMutableArray *patientNames = [NSMutableArray new];
    for (Exam *exam in exams) {
        if(![patientNames containsObject:exam.patientName]){
            [patientNames addObject:exam.patientName];
        }
    }
    
    //
    NSMutableDictionary *examsByPatientName = [NSMutableDictionary new];
    for (NSString *pName in patientNames) {
        [examsByPatientName setObject:[exams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"petName == %@", pName]] forKey:pName];
    }
    
    return [NSDictionary dictionaryWithDictionary:examsByPatientName];
}

+ (NSArray*)getAllPatients
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exam" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"petName"]];
    fetchRequest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionaries = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:nil];
   
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in dictionaries) {
        NSString *petName = dic[@"petName"];
        if (petName) {
            [result addObject:petName];
        }
    }
    
    return result;
}

#pragma mark by Date

+ (NSDictionary*)getWithStartDate:(NSDate*)startDate eneDate:(NSDate*)endDate
{
    return [Exam fetchRequestWithPredicate:[Exam predicateWithStartDate:startDate eneDate:endDate]];
}


+ (NSPredicate*)predicateWithStartDate:(NSDate*)startDate eneDate:(NSDate*)endDate
{
    return [NSPredicate predicateWithFormat:@"(date >= %@) && (date <= %@)", [startDate dateWith0AMTime], [endDate dateWith23PMTime]];
}

#pragma mark By Patient & Date

+ (NSDictionary*)getContainsPatientName:(NSString*)patientName startDate:(NSDate*)startDate eneDate:(NSDate*)endDate
{
    NSPredicate *predicateGeneral = [NSCompoundPredicate andPredicateWithSubpredicates:@[[Exam predicateWithStartDate:startDate eneDate:endDate], [Exam predicateWithContainsPatientName:patientName]]];
    
    return [Exam fetchRequestWithPredicate:predicateGeneral];
}

#pragma mark Sync

+ (void)synchronize:(NSArray*)examsByServer
{
    NSError *error;
    NSArray *allExams = [Exam getAllOrderByDate];
    
    if (allExams.count != examsByServer.count && examsByServer.count != 0) {
        for (Exam *exam in allExams) {
            if ([Exam array:examsByServer containExam:exam] ==  NO) {
                [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:exam];
            }
        }
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext save:&error];
    }
    
    if (examsByServer.count == 0) {
        for (Exam *exam in allExams) {
            [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:exam];
        }
    }
}

+ (BOOL)array:(NSArray*)exams containExam:(Exam*)exam
{
    for (Exam *myExam in exams) {
        if ([myExam.iD isEqualToString:exam.iD]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Override Get/Set

- (NSString*)fileSystemPath
{
    NSString *nameFile = [NSString stringWithFormat:@"%@.pdf",self.name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:nameFile];
}

- (NSString*)patientName
{
    return self.petName;
}

- (void)setFileURL:(NSString *)fileURL
{
    if ([self isPDFFile] && ![fileURL isEqualToString:self.fileURL] && ![self.fileURL isEqualToString:@""] && self.fileURL != nil) {
        [self removePDFFile];

        [self setIsPersisted:@NO];
        NSError *error;
        [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
        
    }

    [self willChangeValueForKey:@"fileURL"];
    [self setPrimitiveValue:fileURL forKey:@"fileURL"];
    [self didChangeValueForKey:@"fileURL"];
}

#pragma mark - PDF Manage

- (void)removePDFFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    if ([fileManager removeItemAtPath:[self fileSystemPath] error:&error]) {
        NSLog(@"File Deleted -:%@ ",[self fileSystemPath]);
    }else{
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (BOOL)isPDFFile
{
    return ([self.fileType isEqualToString:@"application/pdf"]);
}


@end
