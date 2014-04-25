//
//  BCAppDelegate.h
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "defines.h"

@interface BCAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationMgr;

@end
