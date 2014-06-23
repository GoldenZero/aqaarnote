//
//  AppDelegate.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIStoryboard;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboardVC;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

- (BOOL) onErrorScreen;
- (NSArray*)getAllCarsRecords;
- (NSArray*)getAllHotels;
- (NSArray*)getAllMadinaHotels;
@end
