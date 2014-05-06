//
//  BCViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 4/26/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController

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

    // Adds background image
    UIImage *patternImage = [UIImage imageNamed:@"bgtile"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
}

- (void)showCamera
{
    // General show camera method with picker fallback for iPhone simulator
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.editing = NO;
    imagePickerController.showsCameraControls = YES;
#endif
    
    imagePickerController.delegate = (id)self;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
