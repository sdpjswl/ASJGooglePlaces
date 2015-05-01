//
//  SJAutocomplete.h
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJSession.h"

@interface SJAutocomplete : SJSession

@property (nonatomic) NSUInteger minimumInputLength;

- (void)sjAutocompleteForInput:(NSString *)input
					completion:(void (^)(SJResponseStatusCode statusCode, NSArray *places))completion;

@end
