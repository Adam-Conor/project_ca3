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
static NSString *status = @"none";
static NSIndexPath *indexPath;
static NSString *date;
static NSString *locale;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL inputError = NO;
    NSDate *date = self.datePicker.date;
    PFUser *user = [PFUser currentUser];
    if([user objectForKey:@"emailVerified"] == NO){
        //NSLog([user objectForKey:@"emailVerified"]);
        NSString *alertTitle = @"You are not a verified user. Please verify your email account through the email we sent you when you signed up.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        NSLog(@"Not verified, tut tut.");
    }
    else{
        NSString *alertTitle = @"Title, Category, Status and Description are all mandatory fields. Please make sure these are filled before placing listing.";
        if([_listingTitle.text isEqualToString:@""] || [status isEqualToString:@"none"] || [self.category isEqualToString:@""] || [_desc.text isEqualToString:@""]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
        }
        else{
            PFObject *listing = [PFObject objectWithClassName:@"Listing"];
            [listing setObject:_listingTitle.text forKey:@"title"];
            listing[@"category"] = self.category; //
            listing[@"user"] = user;
            listing[@"status"] = status;
            [listing setObject:_desc.text forKey:@"description"];
            listing[@"date"] = date;
            if(self.uploadImage){
                listing[@"image"] = self.uploadImage;
            }
            if(self.loc){
                listing[@"location"] = self.loc;
                listing[@"locale"] = locale;
            }
        
            [listing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) NSLog(@"%s Listing saved succesfully.", __PRETTY_FUNCTION__);
                else NSLog(@"%s Listing was not saved.", __PRETTY_FUNCTION__);
            }];
            [self performSegueWithIdentifier:@"saveListing" sender:nil];
        }
    }
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

- (void) getLocale{
    CLLocation *locat = [[CLLocation alloc] initWithLatitude:self.loc.latitude longitude:self.loc.longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locat completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locale = [placemark locality];
        //NSLog([placemark subAdministrativeArea]);
        NSLog(@"%@",locale);
    }];
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

-(IBAction)sendLocation:(UIStoryboardSegue *)segue {
    NSLog(@"Nice, should have geo point");
    NSLog(@"%f %f", self.loc.latitude, self.loc.longitude);
    [self getLocale];
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
- (IBAction)getLocation:(id)sender {
}

- (IBAction)getImage:(id)sender {
    
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