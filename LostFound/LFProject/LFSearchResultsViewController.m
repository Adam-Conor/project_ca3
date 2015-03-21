//
//  LFSearchResultsViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFSearchResultsViewController.h"

@interface LFSearchResultsViewController ()

@end

@implementation LFSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        NSLog(@"Trying to get shit");
        self.parseClassName = @"Listing";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    PFQuery* listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery whereKey:@"category" equalTo:@"personal"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    PFUser *user = [object objectForKey:@"user"];
    PFFile *image = [object objectForKey:@"image"];
    PFImageView *imageView = (PFImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"placeholder.png"];
    imageView.file = image;
    [imageView loadInBackground];
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
    
    UILabel *categoryLabel = (UILabel*) [cell viewWithTag:102];
    categoryLabel.text = [object objectForKey:@"category"];
    
    UILabel *userLabel = (UILabel*) [cell viewWithTag:103];
    userLabel.text = user.username;
    
    UILabel *dateLabel = (UILabel*) [cell viewWithTag:104];
    dateLabel.text = [object objectForKey:@"date"];
    
    UILabel *localeLabel = (UILabel*) [cell viewWithTag:105];
    localeLabel.text = [object objectForKey:@"locale"];

    UILabel *statusLabel = (UILabel*) [cell viewWithTag:106];
    statusLabel.text = [object objectForKey:@"status"];

    
    return cell;
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}


@end
