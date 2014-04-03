//
//  BCInboxViewCell.h
//  Bathchat
//
//  Created by Derek Schultz on 4/3/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BCInboxViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *picture;
@property (nonatomic, strong) PFObject *message;
@property (nonatomic, strong) UIImage *messagePhoto;
@property (nonatomic, strong) UIImageView *messageView;

- (void)markAsRead;

@end
