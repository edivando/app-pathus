//
//  NSString+Utility.m
//  PetProject
//
//  Created by Lucas Torquato on 2/21/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "NSString+Utility.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Utility)

- (BOOL)containsSubstring:(NSString*)subString
{
    return ([self rangeOfString:subString].location != NSNotFound);
}

- (NSDate*)toBRDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    return [formatter dateFromString:self];
}

- (NSString *)sha512StringWithHMACKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
    
    return HMAC;
}

- (BOOL)isNilOrEmpty
{
    return (self == nil || [self isEqual:@""]);
}

@end
