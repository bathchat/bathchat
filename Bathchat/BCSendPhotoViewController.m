//
//  BCSendPhotoViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 4/1/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCSendPhotoViewController.h"

@protocol RPSGraphActionList<FBOpenGraphAction>
@property (retain, nonatomic) NSArray *data;
@end

@interface BCSendPhotoViewController () <FBFriendPickerDelegate>

@property (readwrite, nonatomic, copy) NSString *fbidSelection;
@property (readwrite, nonatomic, retain) FBFrictionlessRecipientCache *friendCache;
@property (nonatomic, strong) PFFile* uploadedFile;
@property (nonatomic, strong) NSArray* selectedRecipients;

- (void)updateActivityForID:(NSString *)fbid;

@end

@implementation BCSendPhotoViewController

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initing with coder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fieldsForRequest = [NSSet setWithObject:@"installed"];
        self.allowsMultipleSelection = NO;
        self.delegate = self;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Start uploading the image right away while the user chooses recipients
    NSData *imageData = UIImageJPEGRepresentation(_photo, 0.6f);
    _uploadedFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [_uploadedFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView {
    [self loadData];
    
    // we use frictionless requests, so let's get a cache and request the
    // current list of frictionless friends before enabling the invite button
    if (!self.friendCache) {
        self.friendCache = [[FBFrictionlessRecipientCache alloc] init];
        [self.friendCache prefetchAndCacheForSession:nil
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       
//                                       self.inviteButton.enabled = YES;
                                   }];
    } else  {
        // if we already have a primed cache, let's just run with it
//        self.inviteButton.enabled = YES;
    }
}

- (IBAction)sendMessage {
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"sender"] = [PFUser currentUser];
    message[@"photo"] = _uploadedFile;
    
    NSMutableArray* recipientList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_selectedRecipients count]; i++) {
        NSDictionary<FBGraphUser>* graphUser = [_selectedRecipients objectAtIndex:i];
        [recipientList addObject:graphUser.id];
    }
    
    PFQuery* findRecipients = [PFQuery queryWithClassName:@"_User"];
    [findRecipients whereKey:@"facebookId" containedIn:recipientList];
    [findRecipients findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"adding recipients");
            message[@"recipients"] = objects;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [message saveInBackground];
    }];
    [self performSegueWithIdentifier:@"UnwindToInboxSegue" sender:self];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (FBSession.activeSession.isOpen) {
        [self refreshView];
    } else {
//        self.inviteButton.enabled = NO;
        self.friendCache = nil;
        
        // display the message that we have
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In with Facebook"
                                                        message:@"When you Log In with Facebook, you can view "
                              @"friends' activity within Rock Paper Scissors, and "
                              @"invite friends to play.\n\n"
                              @"What would you like to do?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Log In", nil];
        [alert show];
    }
}

- (void)viewDidUnload {
//    self.activityTextView = nil;
    
//    [self setInviteButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma mark - FBFriendPickerDelegate implementation

// FBSample logic
// The following two methods implement the FBFriendPickerDelegate protocol. This shows an example of two
// interesting SDK features: 1) filtering support in the friend picker, 2) the "installed" field field when
// fetching me/friends. Filtering lets you choose whether or not to display each friend, based on application
// determined criteria; the installed field is present (and true) if the friend is also a user of the calling
// application.

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
//    self.activityTextView.text = @"";
    _selectedRecipients = friendPicker.selection;
    if (friendPicker.selection.count) {
        [self updateActivityForID:[[friendPicker.selection objectAtIndex:0] id]];
    } else {
//        self.fbidSelection = nil;
    }
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user {
    return [[user objectForKey:@"installed"] boolValue];
}

#pragma mark - private methods

// FBSample logic
// This is the workhorse method of this view. It updates the textView with the activity of a given user. It
// accomplishes this by fetching the "throw" actions for the selected user.
- (void)updateActivityForID:(NSString *)fbid {
    
    // keep track of the selction
    // self.fbidSelection = fbid;
    
    // create a request for the "throw" activity
    FBRequest *playActivity = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/fb_sample_rps:throw", fbid]];
    [playActivity.parameters setObject:@"U" forKey:@"date_format"];
    
    // this block is the one that does the real handling work for the requests
    void (^handleBlock)(id) = ^(id<RPSGraphActionList> result) {
//        if (result) {
//            for (id<RPSGraphPublishedThrowAction> entry in result.data) {
//                // we  translate the date into something useful for sorting and displaying
//                entry.publish_date = [NSDate dateWithTimeIntervalSince1970:entry.publish_time.intValue];
//            }
//        }
//        
//        // sort the array by date
//        NSMutableArray *activity = [NSMutableArray arrayWithArray:result.data];
//        [activity sortUsingComparator:^NSComparisonResult(id<RPSGraphPublishedThrowAction> obj1,
//                                                          id<RPSGraphPublishedThrowAction> obj2) {
//            if (obj1.publish_date && obj2.publish_date) {
//                return [obj2.publish_date compare:obj1.publish_date];
//            }
//            return NSOrderedSame;
//        }];
//        
//        NSMutableString *output = [NSMutableString string];
//        for (id<RPSGraphPublishedThrowAction> entry in activity) {
//            NSDateComponents *c = [[NSCalendar currentCalendar]
//                                   components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
//                                   fromDate:entry.publish_date];
//            [output appendFormat:@"%02li/%02li/%02li - %@ %@ %@\n",
//             (long)c.month,
//             (long)c.day,
//             (long)c.year,
//             entry.data.gesture.title,
//             @"vs",
//             entry.data.opposing_gesture.title];
//        }
//        self.activityTextView.text = output;
    };
    
    // this is an example of a batch request using FBRequestConnection; we accomplish this by adding
    // two request objects to the connection, and then calling start; note that each request handles its
    // own response, despite the fact that the SDK is serializing them into a single request to the server
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:playActivity
         completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
             handleBlock(result);
         }];
    // start the actual request
    [connection start];
}

- (IBAction)clickInviteFriends:(id)sender {
    // if there is a selected user, seed the dialog with that user
//    NSDictionary *parameters = self.fbidSelection ? @{@"to":self.fbidSelection} : nil;
//    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
//                                                  message:@"Please come play RPS with me!"
//                                                    title:@"Invite a Friend"
//                                               parameters:parameters
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (result == FBWebDialogResultDialogCompleted) {
//                                                          NSLog(@"Web dialog complete: %@", resultURL);
//                                                      } else {
//                                                          NSLog(@"Web dialog not complete, error: %@", error.description);
//                                                      }
//                                                  }
//                                              friendCache:self.friendCache];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    switch (buttonIndex) {
//        case 0: // do nothing
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            break;
//        case 1: { // log in
//            // we will update the view *once* upon successful login
//            __block RPSFriendsViewController *me = self;
//            [FBSession openActiveSessionWithReadPermissions:nil
//                                               allowLoginUI:YES
//                                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                              if (me) {
//                                                  if (session.isOpen) {
//                                                      [me refreshView];
//                                                  } else {
//                                                      [me.navigationController popToRootViewControllerAnimated:YES];
//                                                  }
//                                                  me = nil;
//                                              }
//                                          }];
//            
//            break;
//        }
//    }
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
