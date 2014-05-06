//
//  BCLoginViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "Bathchat.h"

@interface BCLoginViewController : BCViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end
