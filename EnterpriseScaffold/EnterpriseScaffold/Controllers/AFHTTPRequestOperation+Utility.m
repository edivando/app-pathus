//
//  AFHTTPRequestOperation+Utility.m
//  PetProject
//
//  Created by Lucas Torquato on 2/21/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "AFHTTPRequestOperation+Utility.h"
#import "NSString+Utility.h"

@implementation AFHTTPRequestOperation (Utility)

- (NSString*)translateOperationError
{
    NSString *reponseBody = [[[self error] userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
    
    if (reponseBody != nil && ![reponseBody isEqualToString:@""]) {
        if ([reponseBody containsSubstring:@"Invalid login or password"] || [reponseBody containsSubstring:@"user cannot be found"]) {
            return @"Credenciais inválidas - Login ou senha";
            
        }else if ([reponseBody containsSubstring:@"Token Invalid"]){
            return @"Token Invalid";
            
        }else if ([reponseBody containsSubstring:@"Login ou senha inválidos"]){
            return @"Login ou senha inválidos";
            
        }else if ([reponseBody containsSubstring:@"Não existe usuário registrado com este login"]){
            return @"Não existe usuário registrado com este login";
            
        }else{
            return @"Verifique sua conexão com a internet.";
        }
    }
    return @"Verifique sua conexão com a internet.";
}


- (NSString*)translateValidationError
{
    NSString *responseBody = [[[self error] userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
    NSData *jsonData = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];

    NSString *errorMessage = @"";
    if ([dict[@"message"] isKindOfClass:[NSString class]]) {
        
        errorMessage = dict[@"message"];
        
    }else{
        
        for (NSString *key in [dict[@"message"] allKeys])
        {
            NSArray *errorsOfKey = dict[@"message"][key];
            if (errorsOfKey.count > 0)
            {
                for (NSString *validationError in errorsOfKey) {
                    errorMessage = [NSString stringWithFormat:@"%@%@ - %@\n ",errorMessage, key, validationError];
                }
            }
        }
    }
    
    return errorMessage;
}


@end
