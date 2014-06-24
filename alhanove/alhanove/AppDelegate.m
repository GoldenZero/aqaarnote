//
//  AppDelegate.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AppDelegate.h"
#import "CarEntity.h"
#import "HotelEntity.h"
#import "HotelMadinaEntity.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self saveCarsData];
        [self saveMadinaHotelsData];
        [self saveMekkaHotelsData];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController* vc;
    
    self.storyboardVC = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
    vc = [self.storyboardVC instantiateViewControllerWithIdentifier:@"StartWithHome"];
        
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) onErrorScreen {
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wrong_error",@"") message:NSLocalizedString(@"connection_error",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    }
    return NO;
}

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Data.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSArray*) getAllBookings{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookingEntity"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;

}

-(NSArray*)getAllCarsRecords
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarEntity"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (NSArray*)getAllHotels{
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotelEntity"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;

}

- (NSArray*)getAllMadinaHotels{
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotelMadinaEntity"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
    
}

-(void)saveCarsData
{
    
    CarEntity * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"cheverolet spark";
    newEntry.type=@"";
    newEntry.image= @"cheverolet.jpg";
    newEntry.cost=[NSNumber numberWithInt:38];
    newEntry.cost_all=[NSNumber numberWithLong:38 * 1];
    
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Nissan Sunny";
    newEntry.type=@"";
    newEntry.image= @"Sunny.jpg";
    newEntry.cost=[NSNumber numberWithInt:42];
    newEntry.cost_all=[NSNumber numberWithLong:42 * 1];
    
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Cheverolet Aveo";
    newEntry.type=@"";
    newEntry.image= @"Aveo.jpg";
    newEntry.cost=[NSNumber numberWithInt:46];
    newEntry.cost_all=[NSNumber numberWithLong:46 * 1];
    
    
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Dodge Avenger";
    newEntry.type=@"";
    newEntry.image= @"dodge.jpg";
    newEntry.cost=[NSNumber numberWithInt:80];
    newEntry.cost_all=[NSNumber numberWithLong:80 * 1];
    
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Nissan Altima";
    newEntry.type=@"";
    newEntry.image= @"altima.jpg";
    newEntry.cost=[NSNumber numberWithInt:89];
    newEntry.cost_all=[NSNumber numberWithLong:89 * 1];
    
}

- (void) saveMekkaHotelsData{
    
    HotelEntity * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelEntity"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"هيلتون";
    newEntry.stars=[NSNumber numberWithInt:5];
    newEntry.image= @"hilton.jpg";
    newEntry.cost=[NSNumber numberWithInt:480];
    newEntry.cost_all=[NSNumber numberWithLong:480 * 1];

  
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"دار التوحيد";
    newEntry.stars=[NSNumber numberWithInt:3];
    newEntry.image= @"dar al tawhed.jpg";
    newEntry.cost=[NSNumber numberWithInt:200];
    newEntry.cost_all=[NSNumber numberWithLong:200 * 1];
   
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"ميريديان";
    newEntry.stars=[NSNumber numberWithInt:5];
    newEntry.image= @"meredian.jpg";
    newEntry.cost=[NSNumber numberWithInt:600];
    newEntry.cost_all=[NSNumber numberWithLong:600 * 1];

    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"إيلاف كندا";
    newEntry.stars=[NSNumber numberWithInt:4];
    newEntry.image= @"elaf kinda.jpg";
    newEntry.cost=[NSNumber numberWithInt:260];
    newEntry.cost_all=[NSNumber numberWithLong:260 * 1];
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"أجياد مكة مكارم";
    newEntry.stars=[NSNumber numberWithInt:3];
    newEntry.image= @"Ajyad.jpg";
    newEntry.cost=[NSNumber numberWithInt:320];
    newEntry.cost_all=[NSNumber numberWithLong:320 * 1];
    
}


- (void) saveMadinaHotelsData{
    
    HotelMadinaEntity * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                                           inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"هيلتون";
    newEntry.stars=[NSNumber numberWithInt:5];
    newEntry.image= @"hilton.jpg";
    newEntry.cost=[NSNumber numberWithInt:600];
    newEntry.cost_all=[NSNumber numberWithLong:600 * 1];
    
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"أوبروي";
    newEntry.stars=[NSNumber numberWithInt:3];
    newEntry.image= @"dar al tawhed.jpg";
    newEntry.cost=[NSNumber numberWithInt:200];
    newEntry.cost_all=[NSNumber numberWithLong:200 * 1];
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"دار التقوى";
    newEntry.stars=[NSNumber numberWithInt:3];
    newEntry.image= @"meredian.jpg";
    newEntry.cost=[NSNumber numberWithInt:440];
    newEntry.cost_all=[NSNumber numberWithLong:440 * 1];
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"الحرم";
    newEntry.stars=[NSNumber numberWithInt:4];
    newEntry.image= @"elaf kinda.jpg";
    newEntry.cost=[NSNumber numberWithInt:300];
    newEntry.cost_all=[NSNumber numberWithLong:300 * 1];
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"ديار انترناشيونال";
    newEntry.stars=[NSNumber numberWithInt:4];
    newEntry.image= @"Ajyad.jpg";
    newEntry.cost=[NSNumber numberWithInt:410];
    newEntry.cost_all=[NSNumber numberWithLong:410 * 1];
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"ديار";
    newEntry.stars=[NSNumber numberWithInt:3];
    newEntry.image= @"hilton.jpg";
    newEntry.cost=[NSNumber numberWithInt:360];
    newEntry.cost_all=[NSNumber numberWithLong:360 * 1];
    
    
    newEntry = nil;
    newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"HotelMadinaEntity"
                                             inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"موفينبيك انوار المدينة";
    newEntry.stars=[NSNumber numberWithInt:5];
    newEntry.image= @"meredian.jpg";
    newEntry.cost=[NSNumber numberWithInt:520];
    newEntry.cost_all=[NSNumber numberWithLong:520 * 1];

}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end
