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
    [_remove setHidden:YES];
    /* Load listings onto map */
    [self loadListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Load the required listing */
- (void) loadListing {
    PFQuery* listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectId];
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            self.listing = [objects objectAtIndex:0];
            
            /* Get infor about user who posted ad */
            
            PFQuery *query = [PFUser query];
            PFUser *user = _listing[@"user"];
            [query whereKey:@"objectId" equalTo:user.objectId];
            self.poster = [query getFirstObject];
            NSLog(self.poster.username);
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
            
            
            PFUser *current = [PFUser currentUser];
            
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

- (void)removeListing {
    PFQuery *listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectId];
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            PFObject *toRemove = objects[0];
            [toRemove deleteInBackground];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your listing has been deleted!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    //[self performSegueWithIdentifier:@"removeListing" sender:self];
}

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


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
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