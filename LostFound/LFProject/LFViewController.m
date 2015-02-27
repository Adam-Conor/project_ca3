//
//  ParseStarterProjectViewController.m
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import "LFViewController.h"
#import "LFLoginViewController.h"

#import <Parse/Parse.h>

@implementation LFViewController

#pragma mark -
#pragma mark UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    /*PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    [self updateListing];*/
}


- (IBAction)showViewController:(id)sender {
    NSLog(@"showViewController");
    
    LFViewController *viewController = [[LFViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}




/*- (void)createListing {
    PFObject *lis = [PFObject objectWithClassName:@"Listing"];
    lis[@"item"] = @"bobble";
    [lis saveInBackground];
}

- (void)updateListing {
PFQuery *query = [PFQuery queryWithClassName:@"Listing"];

// Retrieve the object by id
[query getObjectInBackgroundWithId:@"pC9DhlZvFM" block:^(PFObject *lis, NSError *error) {
    
    // Now let's update it with some new data. In this case, only cheatMode and score
    // will get sent to the cloud. playerName hasn't changed.
    lis[@"description"] = @"Found near navan";
    lis[@"item"] = @"swills";
    [lis saveInBackground];
    
}];
}*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
