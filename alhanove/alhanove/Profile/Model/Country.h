//
//  Country.h
//  LemoTaxi
//
//  Created by GALMarei on 3/6/14.
//  Copyright (c) 2014 Webnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* dialCode;
@property (nonatomic, readonly) NSString* code;


@end

