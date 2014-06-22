//
//  CarEntity.h
//  alhanove
//
//  Created by Noor on 6/22/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarEntity : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * cost_all;
@property (nonatomic, retain) NSString * image;

@end
