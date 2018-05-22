//
//  AFHTTPRequestOperation+Utility.h
//  PetProject
//
//  Created by Lucas Torquato on 2/21/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "AFHTTPRequestOperation.h"


@interface AFHTTPRequestOperation (Utility)

- (NSString*)translateOperationError;
- (NSString*)translateValidationError;

@end
