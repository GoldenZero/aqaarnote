//
//  BookingEntity.h
//  alhanove
//
//  Created by Noor on 6/23/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CarEntity;

@interface BookingEntity : NSManagedObject

@property (nonatomic, retain) NSString * formPlace;
@property (nonatomic, retain) NSString * toPlace;
@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSNumber * bookingID;
@property (nonatomic, retain) CarEntity *relationship;

@end
