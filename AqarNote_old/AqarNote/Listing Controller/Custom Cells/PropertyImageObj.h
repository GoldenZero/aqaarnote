//
//  PropertyImageObj.h
//  AqarNote
//
//  Created by Noor on 5/18/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyImageObj : NSObject

#pragma mark - Properties 

@property (nonatomic,strong) PFObject * imagePFObject;

@property BOOL Deleted;

@property BOOL Added;

@property int location;
#pragma mark - Methods

- (id)initWithObject:(PFObject*) img andDeleteFlag:(BOOL) deleteFlag andAddedFlag:(BOOL) addedFlag withLocation:(int) number;

@end
