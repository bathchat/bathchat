//
//  BCInboxViewCell.m
//  Bathchat
//
//  Created by Derek Schultz on 4/3/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCInboxViewCell.h"

@implementation BCInboxViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.25;
    [self addGestureRecognizer:longPress];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)markAsRead {
    [self.picture.layer setBorderWidth:0];
    [self.nameLabel setTextColor:[UIColor lightGrayColor]];
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [_messageView removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self markAsRead];
        _message[@"read"] = [NSNumber numberWithBool:YES];
        [_message saveInBackground];
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
        if (!_message[@"read"]) {
            NSLog(@"UIGestureRecognizerStateBegan.");
            _messageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         [[UIScreen mainScreen] bounds].size.width,
                                                                         [[UIScreen mainScreen] bounds].size.height)];
            _messageView.image = _messagePhoto;
            [_messageView setBackgroundColor:[UIColor blackColor]];
            _messageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.window addSubview:_messageView];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
