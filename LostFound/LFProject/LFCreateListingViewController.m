//
//  LFCreateListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFCreateListingViewController.h"
#import "LFCategoriesViewController.h"

@interface LFCreateListingViewController () 

@end

static NSString *status = @"none";
static NSIndexPath *indexPath;
static NSString *date;
static BOOL hasImage = NO;
static BOOL hasLocation = NO;

@implementation LFCreateListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /* Set max date as current date */
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self
                        action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
}

/* Save Listing button
 * Calls create listing function
 */
- (IBAction)saveListing:(id)sender {
    [self createListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    date = strDate;
}

/* Creates listing in database
 * Warns user for errors
 * Posts listing to databse if no errors
 */
- (void) createListing {
    NSDate *date = self.datePicker.date;
    PFUser *user = [PFUser currentUser];
    [user fetch]; 
    /*NSLog(@"%@", user[@"emailVerified"]);
    BOOL verified = user[@"emailVerified"];*/
    
    /* Alert user that they are not verified */
    if( ![[user objectForKey:@"emailVerified"] boolValue] ){
        NSString *alertTitle = @"You are not a verified user. Please verify your email account through the email we sent you when you signed up.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        
        [alertView show];
    } else {
        /* Alert user to fill mandatory fields */
        NSString *alertTitle = @"Title, Category, Status and Description are all mandatory fields. Please make sure these are filled before placing listing.";
        
        if([_listingTitle.text isEqualToString:@""]
           || [status isEqualToString:@"none"]
           || [self.category isEqualToString:@""]
           || [_desc.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            
            [alertView show];
        } else {
            /* Get listing information from fields */
            PFObject *listing = [PFObject objectWithClassName:@"Listing"];
            
            [listing setObject:_listingTitle.text forKey:@"title"];
            
            listing[@"category"] = self.category;
            NSLog(@"%@",self.category);
            listing[@"user"] = user;
            listing[@"status"] = status;
            [listing setObject:_desc.text forKey:@"description"];
            listing[@"date"] = date;

            /* Get image ; Optional */
            if(hasImage){
                listing[@"image"] = self.uploadImage;
            }
                
            /* get location ; Optional */
            if(hasLocation){
                NSLog(@"has Location %@", self.loc);
                listing[@"location"] = self.loc;
                listing[@"locale"] = self.locale;
            }
            
            
            NSLog(@"%@", listing);
            /* Save listing */
            [listing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) NSLog(@"%s Listing saved succesfully.", __PRETTY_FUNCTION__);
                else NSLog(@"%s Listing was not saved.", __PRETTY_FUNCTION__);
            }];
            
            /* Preform segue transition */
            [self performSegueWithIdentifier:@"saveListing" sender:nil];
        }
    }
}

/* Table view for lost/found selection
 * Only allows one selection
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.section;
    if(cell.tag == 2){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = indexPath.row;
        if(cell.tag == 0) {
            status = @"lost";
        }
        else {
            status = @"found";
        }
    }
    else {
        cell.accessoryType = UITableViewCellSelectionStyleNone;
    }
}

/* Gets listing locale
 * Gives name of area near listing
 */

-(void)getLocale{
    CLLocation *locat = [[CLLocation alloc] initWithLatitude:self.loc.latitude longitude:self.loc.longitude];
   
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:locat completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if([placemark.locality isEqualToString:@""]){
                self.locale = placemark.region;
            }
            else{
                self.locale = placemark.locality;
            }
            
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}

/* Data is received from previous view controller to this method */

-(IBAction)sendData:(UIStoryboardSegue *)segue {
    // Capitalise First letter for label on UI
    if([self.category isEqualToString:@""]){
        self.catLabel.text = @"No Category Chosen";
    } else {
        NSString *upper = self.category;
        upper = [self.category capitalizedString];
        self.catLabel.text = upper;
    }
}

/* Receive location from placed pin */
-(IBAction)sendLocation:(UIStoryboardSegue *)segue {
    if(self.loc.latitude != 0 && self.loc.longitude != 0){
        NSLog(@"%@", self.loc);
        hasLocation = YES;
        self.locale = @"";
        [self getLocale];
    }
    else{
        self.loc.latitude = 0;
        self.loc.longitude = 0;
        NSLog(@"No location given, %@", hasLocation);
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == 0 ) return nil;
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    if(cell.tag == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(cell.tag == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

/* Get listing location
 * Goes to map view where user chooses location
 */
- (IBAction)getLocation:(id)sender {}

/* Gets image from user
 * Allows user to upload image to listing
 */
- (IBAction)getImage:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

/* If user cancels image pick dimisses controller */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Controls getting the image and uploading it */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    self.uploadImage = [PFFile fileWithData:imageData];
    hasImage = YES;
}

@end