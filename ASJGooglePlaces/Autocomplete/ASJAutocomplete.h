//
//  ASJAutocomplete.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJSession.h"

@interface ASJAutocomplete : ASJSession

@property (nonatomic) NSUInteger minimumInputLength;

- (void)asjAutocompleteForInput:(NSString *)input
					completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *places))completion;

@end
