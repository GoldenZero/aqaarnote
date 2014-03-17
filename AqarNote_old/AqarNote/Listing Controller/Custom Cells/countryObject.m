//
//  countryObject.m
//  AqarNote
//
//  Created by Noor on 3/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "countryObject.h"

@implementation countryObject

@synthesize countryID;
@synthesize countryName;
@synthesize countryNameEn;
@synthesize currencyID;
@synthesize displayOrder;
@synthesize countryCode;


- (id) initWithCountryIDString:(NSString *) aCountryIDString
                   countryName:(NSString *) aCountryName
                 countryNameEn:(NSString *) aCountryNameEn
              currencyIDString:(NSString *) aCurrencyIDString
            displayOrderString:(NSString *) aDisplayOrderString
             countryCodeString:(NSString *) aCountryCode;
{
    self = [super init];
    if (self) {
        // countryID
        self.countryID = aCountryIDString.integerValue;
        
        // countryName
        self.countryName = aCountryName;
        
        // countryNameEn
        self.countryNameEn = aCountryNameEn;
        
        // currencyID
        self.currencyID = aCurrencyIDString.integerValue;
        
        // displayOrder
        self.displayOrder = aDisplayOrderString.integerValue;
        
        // countryCode
        self.countryCode = aCountryCode;
  
    }
    return self;
}



@end
