//
//  BCEditPhotoViewController.h
//  Bathchat
//
//  Created by Derek Schultz on 3/31/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCEditPhotoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *photoView;
@property (nonatomic) UIImage* photo;

- (IBAction)sendPhoto:(id)sender;

@end
