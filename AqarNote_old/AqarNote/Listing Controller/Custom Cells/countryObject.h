//
//  countryObject.h
//  AqarNote
//
//  Created by Noor on 3/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface countryObject : NSObject

#pragma mark - properties
@property (nonatomic)         NSUInteger    countryID;
@property (strong, nonatomic) NSString *    countryName;
@property (strong, nonatomic) NSString *    countryNameEn;
@property (        nonatomic) NSUInteger    currencyID;
@property (nonatomic)         NSUInteger    displayOrder;
@property (strong, nonatomic) NSString *    countryCode;



#pragma mark - methods
- (id) initWithCountryIDString:(NSString *) aCountryIDString
                   countryName:(NSString *) aCountryName
                 countryNameEn:(NSString *) aCountryNameEn
              currencyIDString:(NSString *) aCurrencyIDString
            displayOrderString:(NSString *) aDisplayOrderString
             countryCodeString:(NSString *) aCountryCode;


@end
