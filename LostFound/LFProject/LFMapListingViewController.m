//
//  LFMapListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 18/03/2015.
//
//

#import "LFMapListingViewController.h"

@interface LFMapListingViewController ()

@end

@implementation LFMapListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Hide remove listing button for now */
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
    /* Set up query for objectId */
    PFQuery* listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectPressed];
    
    /* Execute query in background */
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            self.listing = [objects objectAtIndex:0];
            
            /* Get info about user who posted listing */
            PFQuery *query = [PFUser query];
            PFUser *user = _listing[@"user"];
            [query whereKey:@"objectId" equalTo:user.objectId];
            self.poster = [query getFirstObject];
            
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
                
                _image.image = imageFromData;
            } else {
                _image.image = [UIImage imageNamed:@"placeholder.png"];
            }
            
            /* Check if listing created by user */
            PFUser *current = [PFUser currentUser];
            
            /* Display remove listing button if user */
            if(user == current) {
                [_remove setHidden:NO];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)remove:(id)sender {
    [self removeListing];
}


/* Remove listing function
 * Gets the listing objectId and removes it from the database
 * Alerts user that listing is being deleted
 */
- (void)removeListing {
    PFQuery *listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectPressed];
    
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            PFObject *toRemove = objects[0];
            
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