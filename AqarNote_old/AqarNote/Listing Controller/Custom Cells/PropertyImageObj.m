//
//  PropertyImageObj.m
//  AqarNote
//
//  Created by Noor on 5/18/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "PropertyImageObj.h"

@implementation PropertyImageObj


- (id)initWithObject:(PFObject*) img andDeleteFlag:(BOOL) deleteFlag andAddedFlag:(BOOL) addedFlag withLocation:(int) number
{
    self = [super init];
    if (self) {
       
        self.imagePFObject =img;
        
        self.Deleted=deleteFlag;
        
        self.Added=addedFlag;
        
        self.location=number;
    }
    return self;
}
@end
