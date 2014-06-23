//
//  HotelMadinaEntity.h
//  alhanove
//
//  Created by Noor on 6/23/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HotelMadinaEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * cost_all;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * stars;

@end
