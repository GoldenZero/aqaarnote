//
//  AppDelegate.m
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"UXu28FnmnzWgFAhOT67KOrbHu8mw2DN1bc97RYnA"
                  clientKey:@"n3N7P8SmvbnwYJTx9CXLlZYzAmWE58YEcYT1WV7S"];
    [PFFacebookUtils initializeFacebook];
    //[PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];

    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
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

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
    [FBSession.activeSession handleDidBecomeActive];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (void)initialize
{
    //overriding the default iRate strings
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"قيم عقار نوت", @"iRate message title");
    [iRate sharedInstance].message = NSLocalizedString(@"إن أعجبك عقار نوت، هل تسمح بلحظة لتقييمه؟ لن يتطلب الأمر أكثر من دقيقة واحدة. شكراً لدعمك.", @"iRate message");
    [iRate sharedInstance].cancelButtonLabel = NSLocalizedString(@"لا شكراً.", @"iRate decline button");
    [iRate sharedInstance].remindButtonLabel = NSLocalizedString(@"ذكرني لاحقاً.", @"iRate remind button");
    [iRate sharedInstance].rateButtonLabel = NSLocalizedString(@"قيم الآن.", @"iRate accept button");

    [iRate sharedInstance].applicationBundleID = @"com.AqarNote";
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    [[iRate sharedInstance] openRatingsPageInAppStore];
    //enable preview mode
    //[iRate sharedInstance].previewMode = YES;

}

@end
