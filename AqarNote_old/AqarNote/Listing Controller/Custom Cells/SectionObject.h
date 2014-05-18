//
//  SectionObject.h
//  AqarNote
//
//  Created by Noor on 5/18/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionObject : NSObject

#pragma mark - Properies 

@property (nonatomic, strong) PFObject *sectionPFObject;

@property BOOL SectionChosen;

@property BOOL DeleteIfRemoved;

@property BOOL AddIfChosed;



#pragma mark - Methods

- (id)initWithObject:(PFObject*) sectionObj
     andChosenFlag:(BOOL) chosen
      andDeletFlag:(BOOL) deleteFlag
andAddFlag:(BOOL) addFlag;

@end
