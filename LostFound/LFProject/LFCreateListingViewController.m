//
//  LFCreateListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFCreateListingViewController.h"
#import "LFCategoriesViewController.h"
#import <Parse/Parse.h>
#import <Listing.h>
#import <UIKit/UIKit.h>

@interface LFCreateListingViewController () 

@end
static NSString *status;
static NSIndexPath *indexPath;
static NSString *date;
@implementation LFCreateListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(_cat);
    //Set max date as current date :)
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}
- (IBAction)saveListing:(id)sender {
    [self createListing];
    [self performSegueWithIdentifier:@"saveListing" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear{
    //NSLog(@"%@ I'm printing from create listing view", self.category);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.section;
    if(cell.tag == 0 && [status isEqual:@"found"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSLog(@"Should have checkmarked it");
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    NSLog(strDate);
    date = strDate;
}


- (void) createListing{
    NSDate *date = self.datePicker.date;
    PFUser *user = [PFUser currentUser];
    PFObject *listing = [PFObject objectWithClassName:@"Listing"];
    [listing setObject:_listingTitle.text forKey:@"title"];
    listing[@"category"] = self.category; //
    listing[@"user"] = user;
    listing[@"status"] = status;
    [listing setObject:_desc.text forKey:@"description"];
    listing[@"date"] = date;
    listing[@"image"] = self.uploadImage;
    [listing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) NSLog(@"%s Listing saved succesfully", __PRETTY_FUNCTION__);
        else NSLog(@"%s Listing fucked up", __PRETTY_FUNCTION__);
    }];
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.section;
    if(cell.tag == 2){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = indexPath.row;
        if(cell.tag == 0){
            status = @"lost";
        }
        else{
            status = @"found";
        }
    }
    else{
        cell.accessoryType = UITableViewCellSelectionStyleNone;
    }
}


-(IBAction)sendData:(UIStoryboardSegue *)segue {
    // Capitalise First letter for label on UI
    if([self.category isEqualToString:@""]){
        self.catLabel.text = @"No Category Chosen";
        NSLog(@"Cancelled :)");
    }else{
    NSString *upper = self.category;
    upper = [self.category capitalizedString];
    self.catLabel.text = upper;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == 0 ) return nil;
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    if(cell.tag == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if(cell.tag == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (IBAction)nice:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    self.uploadImage = [PFFile fileWithData:imageData];
}

@end