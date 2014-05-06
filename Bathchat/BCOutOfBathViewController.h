//
//  BCOutOfBathViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 4/24/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "Bathchat.h"

@interface BCOutOfBathViewController : BCViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *searchingLabel;
@property (weak, nonatomic) IBOutlet UILabel *failureLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end
