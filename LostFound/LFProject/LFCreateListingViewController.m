//
//  LFCreateListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFCreateListingViewController.h"
#import <Parse/Parse.h>

@interface LFCreateListingViewController ()

@end

@implementation LFCreateListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  createListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createListing{
    PFUser *user = [PFUser currentUser];
    PFObject *listing = [PFObject objectWithClassName:@"Listing"];
    //PFFile *image = ;
    listing[@"category"] = @"animal";
    listing[@"user"] = user;
    listing[@"status"] = @"found";
    listing[@"image"] = @"test";
    [listing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) NSLog(@"%s Listing saved succesfully", __PRETTY_FUNCTION__);
        else NSLog(@"%s Listing fucked up", __PRETTY_FUNCTION__);
    }];

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
