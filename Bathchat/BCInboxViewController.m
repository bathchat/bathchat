//
//  BCInboxViewController.m
//  Bathchat
//
//  Created by Derek Schultz on 3/30/14.
//  Copyright (c) 2014 Bathchat LLC. All rights reserved.
//

#import "BCInboxViewController.h"

@interface BCInboxViewController ()

@property (nonatomic) UIImage* currentPhoto;
@property (nonatomic, strong) NSArray* messages;

@end

@implementation BCInboxViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id) initWithCoder:(NSCoder *) coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIImage *patternImage = [UIImage imageNamed:@"duckybg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl setBackgroundColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(refreshInbox) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshInbox];
}

- (void)refreshInbox {
    PFUser* currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query includeKey:@"sender"];
    [query whereKey:@"recipients" containsAllObjectsInArray:@[currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d messages.", objects.count);
            // Do something with the found objects
            _messages = objects;
            [[self tableView] reloadData];
            [self.refreshControl endRefreshing];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"PhotoTakenSegue"]){
        BCEditPhotoViewController *controller = (BCEditPhotoViewController*)segue.destinationViewController;
        controller.photo = _currentPhoto;
    }
}

- (IBAction)unwindToInbox:(UIStoryboardSegue *)unwindSegue
{
}

- (IBAction)takePhoto:(id)sender {
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

#pragma mark - Image picker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:NO];
    
    // Fix the status bar color if the picker messed it up :-/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    NSLog(@"photo chosen");
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Resize the image from the camera
    //	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(photo.frame.size.width, photo.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    //    // Crop the image to a square (yikes, fancy!)
    //    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -photo.frame.size.width)/2, (scaledImage.size.height -photo.frame.size.height)/2, photo.frame.size.width, photo.frame.size.height)];
    //    // Show the photo on the screen
    //    photo.image = croppedImage;
    _currentPhoto = image;
    
    [self performSegueWithIdentifier:@"PhotoTakenSegue" sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"doing well");
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InboxCell";
    BCInboxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject* message = [_messages objectAtIndex:indexPath.row];
    PFObject* sender = message[@"sender"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", sender[@"first_name"], sender[@"last_name"]];
    cell.picture.image = [UIImage imageWithData:
                          [NSData dataWithContentsOfURL:
                           [NSURL URLWithString:
                            [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=84&height=84", sender[@"facebookId"]]]]];
    cell.picture.layer.masksToBounds = YES;
    cell.picture.layer.cornerRadius = 21;
    [cell.picture.layer setBorderWidth:1.5];
    [cell.picture.layer setBorderColor:[BC_BLUE CGColor]];
    
    cell.messagePhoto = message[@""];
    
    cell.timeLabel.text = @""; // TODO... I don't feel like making this right now
    
    PFFile* file = message[@"photo"];
    NSData *imageData = [file getData];
    UIImage *imageFromData = [UIImage imageWithData:imageData];
    cell.messagePhoto = imageFromData;
                          
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
