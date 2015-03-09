//
//  LFProfileViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import "LFProfileViewController.h"
#import <Parse/Parse.h>
#import "LFSettingsViewController.h"

@interface LFProfileViewController ()

@end

@implementation LFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PFUser *cUser = [PFUser currentUser];
    
    /* Get User information */
    //image somehow
    NSString *user = cUser.username; //username
    NSDate *createdDate = cUser.createdAt; //date
    NSString *email = cUser.email; //email
    //todo//NSString *listingCount = [self getListingCount:(PFUser*)cUser]; //listing count
    [self setFeedback:(PFUser*)cUser]; //feedback
    
    /* Format date */
    NSString *created = [self dateToString:(createdDate)];
    
    /* Image size etc to be moved */
    _imageView.layer.cornerRadius = _imageView.frame.size.height /2;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 0;
    
    /* Populate fields */
    //_imageView //image view
    _usernameField.text = user; //username
    _memberField.text = created; //date
    _emailField.text = email; //email
    //_listingField.text = listingCount; //listing count
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
