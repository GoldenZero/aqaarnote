//
//  BookingEntity.h
//  alhanove
//
//  Created by Noor on 6/24/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CarEntity, HotelEntity, HotelMadinaEntity;

@interface BookingEntity : NSManagedObject

@property (nonatomic, retain) NSString * bookingType;
@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSString * flightClass;
@property (nonatomic, retain) NSNumber * flightCost;
@property (nonatomic, retain) NSNumber * guestsNumber;
@property (nonatomic, retain) NSNumber * roomsNumber;
@property (nonatomic, retain) NSNumber * rentalDays;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userAddress;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * userMobile;
@property (nonatomic, retain) NSDate * bookingDate;
@property (nonatomic, retain) NSNumber * bookingCost;
@property (nonatomic, retain) NSData * passportImage;
@property (nonatomic, retain) NSData * personalImage;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * fromPlace;
@property (nonatomic, retain) NSString * toPlace;
@property (nonatomic, retain) HotelEntity *mekkaHotel;
@property (nonatomic, retain) HotelMadinaEntity *madinaHotel;
@property (nonatomic, retain) CarEntity *carData;

@end
