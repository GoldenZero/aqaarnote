//
//  Country.m
//  LemoTaxi
//
//  Created by GALMarei on 3/6/14.
//  Copyright (c) 2014 Webnet. All rights reserved.
//

#import "Country.h"

@interface Country()
{
    NSString *_name;
    NSString *_dialCode;
    NSString *_code;
    
}
@end


@implementation Country

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _name = dictionary[@"name"];
        _dialCode = dictionary[@"dial_code"];
        _code = dictionary[@"code"];
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"country name: %@, dial_code: %@, code: %@", _name, _dialCode,_code];
}

@end
