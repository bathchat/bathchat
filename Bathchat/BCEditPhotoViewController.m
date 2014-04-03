//
//  BCEditPhotoViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 3/31/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCEditPhotoViewController.h"
#import "BCSendPhotoViewController.h"

@interface BCEditPhotoViewController ()

@end

@implementation BCEditPhotoViewController

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
    _photoView.contentMode = UIViewContentModeScaleAspectFit;
    _photoView.image = _photo;
}

- (IBAction)editComplete:(id)sender {
    [self performSegueWithIdentifier:@"editCompleteSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPhoto:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"editCompleteSegue"]){
        BCSendPhotoViewController *controller = (BCSendPhotoViewController*)segue.destinationViewController;
        controller.photo = _photo;
    }
}

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
