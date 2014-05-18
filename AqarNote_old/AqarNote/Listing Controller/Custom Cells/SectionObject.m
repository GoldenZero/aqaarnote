//
//  SectionObject.m
//  AqarNote
//
//  Created by Noor on 5/18/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "SectionObject.h"

@implementation SectionObject

- (id)initWithObject:(PFObject*) sectionObj
       andChosenFlag:(BOOL) chosen
        andDeletFlag:(BOOL) deleteFlag
          andAddFlag:(BOOL) addFlag
{
    
    self=[super init];
    
    if (self) {
        
        self.sectionPFObject=sectionObj;
        
        self.SectionChosen=chosen;
        
        self.DeleteIfRemoved=deleteFlag;
        
        self.AddIfChosed=addFlag;
        
    }
    return self;
}



@end
