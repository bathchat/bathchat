//
//  BCLoginViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCLoginViewController.h"
#import "BCInboxViewController.h"

@interface BCLoginViewController ()

@end

@implementation BCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If the user is already logged in, continue
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self loginSuccess];
    }
}

- (IBAction)loginButtonTouchHandler:(id)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"email"];

    // Begin the activity indicator and hide the button
    [_activityIndicator startAnimating];
    _loginButton.hidden = YES;
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            // The user failed to log in for some reason. We need to put the button back.
            _loginButton.hidden = NO;
            
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else {
            // Update the PFUser with info retrieved from FB
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     user[@"facebookId"] = [result objectForKey:@"id"];
                     user[@"first_name"] = [result objectForKey:@"first_name"];
                     user[@"last_name"] = [result objectForKey:@"last_name"];
                     [user saveInBackground];
                 }
             }];
            
            // Success
            [self loginSuccess];
        }
    }];
}

- (void)loginSuccess
{
    // Update installation object with user info
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"user"] = [PFUser currentUser];
    [currentInstallation saveInBackground];
    
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
