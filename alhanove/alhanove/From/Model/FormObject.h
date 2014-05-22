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

@property (nonatomic,strong) NSDictionary* MekkaHotelData;
@property (nonatomic,strong) NSDictionary* MadinaHotelData;
@property (nonatomic,strong) NSDictionary* HotelData;
@property (nonatomic,strong) NSString* BookingType;
@property (nonatomic,strong) NSDate *fromDate;
@property (nonatomic,strong) NSDate *toDate;
@property (nonatomic,strong) NSString *FlightClass;
@property (nonatomic,strong) NSString* FlightCost;
@property int guestsNumber;
@property int roomsNumber;



//User Data
@property (nonatomic,strong) NSString* UserName;
@property (nonatomic,strong) NSString* UserAddress;
@property (nonatomic,strong) NSString* UserEmail;
@property (nonatomic,strong) NSString* UserMobile;
@property (nonatomic,strong) NSString* BookingDate;
@property (nonatomic,strong) UIImage* PassportImage;
@property (nonatomic,strong) UIImage* PersonalImage;
@property (nonatomic,strong) NSString* BookingCost;




@end
