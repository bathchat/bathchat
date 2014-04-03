//
//  BCSendPhotoViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 4/1/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface BCSendPhotoViewController : FBFriendPickerViewController

@property (nonatomic) UIImage* photo;

@end
