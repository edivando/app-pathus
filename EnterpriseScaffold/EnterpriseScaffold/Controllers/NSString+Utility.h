//
//  NSString+Utility.h
//  PetProject
//
//  Created by Lucas Torquato on 2/21/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (BOOL)containsSubstring:(NSString*)subString;

- (NSDate*)toBRDate;

- (NSString *)sha512StringWithHMACKey:(NSString *)key;

- (BOOL)isNilOrEmpty;

@end
