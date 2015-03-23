//
//  LFMapListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 18/03/2015.
//
//

#import "LFListingViewController.h"

@interface LFListingViewController ()

@end

@implementation LFListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"listing View loading");
    
    /* Hide remove button for now */
    [_remove setHidden:YES];
    
    /* Load listings onto map */
    [self loadListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Load the required listing
 * Queries database for specified listing
 * Displays text in view controller
 */
- (void) loadListing {
    NSLog(@"Listing is loading");
    
    /* Set up query for objectId */
    PFQuery* listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectId];
    
    /* Execute query in background */
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            NSLog(@"match found for listing");
            self.listing = [objects objectAtIndex:0];
            
            /* Get info about user who posted listing */
            PFQuery *query = [PFUser query];
            PFUser *user = _listing[@"user"];
            [query whereKey:@"objectId" equalTo:user.objectId];
            self.poster = [query getFirstObject];
            
            //show what the query returns
            NSLog(@"Listing returned: %@", _listing);
            
            /* Get listing information from query */
            _listingTitle.text = [self capitalise:_listing[@"title"]];
            _category.text = [self capitalise:_listing[@"category"]];
            _locale.text = _listing[@"locale"];
            _status.text = [self capitalise:_listing[@"status"]];
            _desc.text = _listing[@"description"];
            _date.text = [self dateToString:_listing[@"date"]];
            _user.text = _poster.username;
            _email.text = _poster.email;
            PFFile *fileImage = [_listing objectForKey:@"image"];
            
            /* Check for no image, replace with placeholder */
            if(fileImage != NULL) {
                NSData *imageData = [fileImage getData];
                UIImage *imageFromData = [UIImage imageWithData:imageData];
                NSLog(@"Image");
                _image.image = imageFromData;
            } else {
                NSLog(@"No Image");
                _image.image = [UIImage imageNamed:@"placeholder.png"];
            }
            
            /* Check if listing created by user */
            PFUser *current = [PFUser currentUser];
            
            /* Display remove listing button if user */
            if(user == current) {
                NSLog(@"User owns listing");
                [_remove setHidden:NO];
            }
  
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/* Button action for remove listing */
- (IBAction)remove:(id)sender {
    NSLog(@"Remove listing pressed");
    [self removeListing];
}

/* Remove listing function
 * Gets the listing objectId and removes it from the database
 * Alerts user that listing is being deleted
 */
- (void)removeListing {
    NSLog(@"Remove listing called");
    PFQuery *listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectId];
    
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            NSLog(@"Found object to remove");
            PFObject *toRemove = objects[0];
            
            //show what's being removed
            NSLog(@"Being removed: %@", toRemove);
            
            /* remove object from database */
            [toRemove deleteInBackground];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    /* Alert user the listing will be removed */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Your listing has been deleted!"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    
    [alert show];    
}

/* Email user function
 * Redirects the user to email the listing owner
 * Fills some field information for contactor
 */
- (IBAction)emailUser:(id)sender {
    NSLog(@"Email  user called");
    
    NSString *subject= [self capitalise:_listing[@"title"]];
    NSString *body = @"Hi! I was just wondering about your listing on Lost & Found";
    NSString *email = _poster.email;
    NSArray *toEmail = [NSArray arrayWithObject:email];
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:subject];
    [mc setMessageBody:body isHTML:NO];
    [mc setToRecipients:toEmail];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(NSString*)dateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    NSString *created = [formatter stringFromDate:date];
    
    //what date to string being returned
    NSLog(@"date to string: %@", created);
    
    return created;
}

-(NSString*)capitalise:(NSString*)str {
    NSString *upper;
    upper = [str capitalizedString];
    
    return upper;
}


- (void) mailComposeController:(MFMailComposeViewController *)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError *)error {
    switch(result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end