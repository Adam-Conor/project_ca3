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

/* This to show users current listings */

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
    //NSString *feedback;
    [self getFeedback:(PFUser*)cUser]; //feedback
    //NSLog(@"%@", feedback); //test
    
    /* Format date */
    NSString *created = [self dateToString:(createdDate)];
    
    /* Image size etc to be moved */
    _imageView.layer.cornerRadius = _imageView.frame.size.height /2;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 0;
    
    /* Add progress bar stuff */
    
    /* Populate fields */
    //_imageView //image view
    _usernameField.text = user; //username
    _memberField.text = created; //date
    _emailField.text = email; //email
    //_listingField.text = listingCount; //listing count
    //_feedbackField.text = feedback; //feedback
    
}


-(NSString*)dateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *created = [formatter stringFromDate:date];
    
    return created;
}

-(void)getFeedback:(PFUser*)user {
    NSString *userID = user.objectId;
    __block NSString *feedback;
    //NSArray *objects;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:userID];
    //objects = [query findObjects];
    //feedback = objects[0][@"rating"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"%@", objects[0][]);
            feedback = objects[0][@"rating"];
            //_feedbackField.text = feedback.uppercaseString; //feedback
            NSLog(@"%@", feedback);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //_feedbackField.text = feedback; //feedback
    //NSLog(@"%@", feedback);
    _feedbackField.text = feedback; //feedback
    //return feedback;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signOut:(id)sender {
    //PFUser *user = [PFUser currentUser];
    [PFUser logOut];
    //NSLog(@"%@", user.username);
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
