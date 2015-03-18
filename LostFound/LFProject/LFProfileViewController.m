//
//  LFProfileViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import "LFProfileViewController.h"
#import "LFSettingsViewController.h"

@interface LFProfileViewController ()

@end

@implementation LFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PFUser *cUser = [PFUser currentUser];
    
    /* Get User information */
    [self setImage:(PFUser*)cUser]; //image
    NSString *user = cUser.username; //username
    NSDate *createdDate = cUser.createdAt; //date
    NSString *email = cUser.email; //email
    //int listingCount = [self getListingCount:(PFUser*)cUser]; //listing count
    [self setFeedback:(PFUser*)cUser]; //feedback
    
    /* Format date */
    NSString *created = [self dateToString:(createdDate)];
    
    /* Format the image view */
    [self formatImage:(_imageView)];
    
    /* Populate fields */
    _usernameField.text = user; //username
    _memberField.text = created; //date
    _emailField.text = email; //email
    //NSLog(@"%d", listingCount); //move to viewDIdLoad?
    //_listingField.text = listingCount; //listing count
}

-(void)viewDidAppear:(BOOL)animated {
    PFUser *cUser = [PFUser currentUser];
    int listingCount = [self getListingCount:(PFUser*)cUser];
    
    NSLog(@"%d", listingCount);
}

/* Gets profile picture from database
 * sets the image to the image view
 */
-(void)setImage:(PFUser*)user {
    NSString *userID = user.objectId;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    [query whereKey:@"objectId" equalTo:userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) { //objects found
            PFObject *objectImage = objects[0];
            
            PFFile *fileImage = [objectImage objectForKey:@"prof_image"];
            NSData *imageData = [fileImage getData];
            UIImage *imageFromData = [UIImage imageWithData:imageData];
            
            _imageView.image = imageFromData;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/* Convert a date to a string
 * Takes date
 * Returns as Month/Day/Year
 */
-(NSString*)dateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *created = [formatter stringFromDate:date];
    
    return created;
}

/* Set the image format
 * Makes the image show as a circle
 */
-(void)formatImage:(UIImageView*)image {
    image.layer.cornerRadius = image.frame.size.height / 2;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 0;
}

/* Get the number of listing for current user
 * Return count as int
 */
-(int)getListingCount:(PFUser*)user {
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    __block int listingCount = 0;
    
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            listingCount = sizeof(objects);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return listingCount;
}

/* Set feedback for profile
 * Gets feedback from DB and displays
 * Displays rating on progress bar
 */
-(void)setFeedback:(PFUser*)user {
    /* Set what to query */
    NSString *userID = user.objectId;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    [query whereKey:@"objectId" equalTo:userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            NSString *feedbackAsString;
            float feedbackAsPercent;
            
            feedbackAsString = objects[0][@"rating"];
            feedbackAsPercent = feedbackAsString.floatValue;
            
            /* Catch users with no feedback */
            if(feedbackAsString == NULL) {
                feedbackAsString = @"0";
                feedbackAsPercent = 50;
                _noFeedbackField.text = @"No feedback";
            }
            
            /* Display on profile */
            _feedbackField.text = [NSString stringWithFormat:@"%@%%", feedbackAsString];
            _feedbackBar.progress = (feedbackAsPercent / 100);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* User button to sign out
 * returns user to log in screen
 */
- (IBAction)signOut:(id)sender {
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"logOut" sender:self];
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
