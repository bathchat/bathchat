//
//  BCInboxViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "Bathchat.h"

@interface BCInboxViewController : BCTableViewController <UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)takePhoto:(id)sender;

@end
