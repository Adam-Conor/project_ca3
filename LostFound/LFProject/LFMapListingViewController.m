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
    [self loadListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadListing {
    PFQuery* listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"objectId" equalTo:self.objectPressed];
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            PFObject *listing = [objects objectAtIndex:0];
            PFUser *user = listing[@"user"];
                        NSLog(@"%@", listing);
            _listingTitle.text = [self capitalise:listing[@"title"]];
            _category.text = [self capitalise:listing[@"category"]];
            _locale.text = listing[@"locale"];
            _status.text = [self capitalise:listing[@"status"]];
            _desc.text = listing[@"description"];
            _date.text = [self dateToString:listing[@"date"]];
            _user.text = user.username;
            _email.text = user.email;
            PFFile *fileImage = [listing objectForKey:@"image"];
            if(fileImage != NULL){
                NSData *imageData = [fileImage getData];
                UIImage *imageFromData = [UIImage imageWithData:imageData];
                _image.image = imageFromData;
            }
            else{
                _image.image = [UIImage imageNamed:@"placeholder.png"];
            }
            
            /* Remove and Report button iunder contstruction
             
            PFUser *current = [PFUser currentUser];
            if(user == current){
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self
                           action:@selector(aMethod:)
                 forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Show View" forState:UIControlStateNormal];
                button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
                [self.view addSubview:button];
            }
             
            */
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSString*)dateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    NSString *created = [formatter stringFromDate:date];
    return created;
}

- (NSString*)capitalise:(NSString*)str {
    NSString *upper;
    upper = [str capitalizedString];
    return upper;
}


@end
