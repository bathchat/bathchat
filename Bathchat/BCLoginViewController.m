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
    self.navigationController.navigationBar.hidden = YES;
    PFUser* cu = [PFUser currentUser];
    NSLog(@"%@", cu[@"authData"]);
    NSLog(@"%@", cu[@"objectId"]);
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"email"];
    [_activityIndicator startAnimating];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     user[@"facebookId"] = [result objectForKey:@"id"];
                     user[@"first_name"] = [result objectForKey:@"first_name"];
                     user[@"last_name"] = [result objectForKey:@"last_name"];
                     [user saveInBackground];
                 }
             }];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        } else {
            NSLog(@"User with facebook logged in!");
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     user[@"facebookId"] = [result objectForKey:@"id"];
                     user[@"first_name"] = [result objectForKey:@"first_name"];
                     user[@"last_name"] = [result objectForKey:@"last_name"];
                     [user saveInBackground];
                 }
             }];
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
