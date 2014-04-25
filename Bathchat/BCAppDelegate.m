//
//  BCAppDelegate.m
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <Parse/Parse.h>
#import "BCAppDelegate.h"

@implementation BCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"Hzn5YPU1ylCzBW0QM6LTADxlS8Lj7sWz1iYEDnwF"
                  clientKey:@"snxApwFTqUFn4CyKwk1nyiMgbKfvKcTIoh9kjWC3"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
    [[UINavigationBar appearance] setBarTintColor:BC_BLUE];
    [[UITabBar appearance] setSelectedImageTintColor:BC_BLUE];
    
    [application registerForRemoteNotificationTypes:
                 UIRemoteNotificationTypeBadge |
                 UIRemoteNotificationTypeAlert |
                 UIRemoteNotificationTypeSound];
    
    
    if(![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"You need to enable Location Services");
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        NSLog(@"Region monitoring is not available for this Class");
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        NSLog(@"You need to authorize Location Services for the APP");
    }
        
//    _locationMgr = [[CLLocationManager alloc] init];
//    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
//    _locationMgr.delegate = self;
    
    //[_locationMgr startUpdatingLocation];
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    NSLog(@"DID REGISTER FOR APNS");
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"FAILED TO REGISTER FOR APNS");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"DID RECEIVE PUSH NOTIFICATION");
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
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
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"location updated %@", newLocation);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"location errored");
}

@end
