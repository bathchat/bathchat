//
//  BCInboxViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "defines.h"
#import "BCEditPhotoViewController.h"
#import "BCInboxViewCell.h"

@interface BCInboxViewController : UITableViewController <UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)takePhoto:(id)sender;

@end
