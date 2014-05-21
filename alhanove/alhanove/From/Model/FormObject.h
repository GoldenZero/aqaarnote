//
//  FormObject.h
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormObject : NSObject

#pragma mark - Properties

@property (nonatomic,strong) NSDate *fromDate;
@property (nonatomic,strong) NSDate *toDate;
@property (nonatomic,strong) NSString *FlightClass;
@property int guestsNumber;
@property int roomsNumber;

@end
