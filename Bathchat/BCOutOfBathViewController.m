//
//  BCOutOfBathViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 4/24/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCOutOfBathViewController.h"

@interface BCOutOfBathViewController ()

@end

@implementation BCOutOfBathViewController

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
    
    // Disable back button
    self.navigationItem.hidesBackButton = YES;
    
    // Start checking for bath location
    [self startTimer];
    
    // Hide the failure UI
    _failureLabel.hidden = YES;
    _registerButton.hidden = YES;
    _searchingLabel.hidden = YES;
}

- (IBAction)registerBath:(id)sender {
    [self showCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This will start a repeating timer that will checkForBath
-(IBAction)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(checkForBath:)
                                                userInfo:nil
                                                 repeats:NO];
}

//The method the timer will call when fired
-(void)checkForBath:(NSTimer *)aTimer {
    NSLog(@"Checking for bath");
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            PFQuery *query = [PFQuery queryWithClassName:@"Bath"];
            
            // Interested only in verified baths near user
            // withinMiles:BC_TEN_METERS
            [query whereKey:@"location" nearGeoPoint:geoPoint];
            [query whereKey:@"verified" equalTo:@"yes"];
            
            // Limit what probably won't be too many points anyway
            query.limit = 10;
            
            // Final list of baths
            NSArray *baths = [query findObjects];
            if ([baths count] > 0) {
                NSLog(@"Near a bath");
                [self performSegueWithIdentifier:@"NearBathSegue" sender:self];
                NSLog(@"Should hav errored?");
            }
            else {
                // Failed to find a nearby bath
                // Switch to the failure case UI
                [_searchActivityIndicator stopAnimating];
                _searchingLabel.hidden = YES;
                
                _failureLabel.hidden = NO;
                _registerButton.hidden = NO;
                [self startTimer];
            }
        }
        else {
            [self startTimer];
        }
    }];
}

-(IBAction)stopTimer {
    [self.timer invalidate];
}

#pragma mark - Image picker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:NO];
    
    // Fix the status bar color if the picker messed it up :-/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSLog(@"photo chosen");
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Start uploading the image right away while the user chooses recipients
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6f);
    PFFile *uploadedFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [uploadedFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"image saved");
        if (!error) {
           [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
               PFObject *newBath = [PFObject objectWithClassName:@"Bath"];
               newBath[@"verified"] = @"no";
               NSLog(@"%@", uploadedFile);
               newBath[@"photo"] = uploadedFile;
               newBath[@"location"] = geoPoint;
               newBath[@"owner"] = [PFUser currentUser];
               [newBath saveInBackground];
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                    message:@"Your bath has been submitted for approval."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
