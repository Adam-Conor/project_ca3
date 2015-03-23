//
//  LFSearchResultsViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFSearchResultsViewController.h"
//#import "ListingCell.h"

@interface LFSearchResultsViewController ()


@end

@implementation LFSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ %@", self.searchStatus, self.searchCat);
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
        self.parseClassName = @"Listing";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        //self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    //PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    PFQuery* query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"status" equalTo:self.searchStatus];
    [query whereKey:@"category" equalTo:self.searchCat];
    //[query orderByDescending:@"date"];
    [query findObjects];
    return query;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFQuery *query = [PFUser query];
    PFUser *user = object[@"user"];
    [query whereKey:@"objectId" equalTo:user.objectId];
    user = [query getFirstObject];
    
    PFFile *image = [object objectForKey:@"image"];
    PFImageView *imageView = (PFImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"placeholder.png"];
    imageView.file = image;
    [imageView loadInBackground];
    
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    NSString *list = [object objectForKey:@"title"];
    titleLabel.text = list;
    //NSLog(@"%@", [object objectForKey:@"title"] );
    
    UILabel *categoryLabel = (UILabel*) [cell viewWithTag:102];
    categoryLabel.text = [object objectForKey:@"category"];
    //NSLog(@"%@", [object objectForKey:@"category"]);
    
    
    UILabel *userLabel = (UILabel*) [cell viewWithTag:103];
    userLabel.text = user.username;
    //NSLog(@"%@", user.username);
    
    UILabel *dateLabel = (UILabel*) [cell viewWithTag:104];
    dateLabel.text = [self dateToString:object[@"date"]];
    //NSLog(@"%@", [object objectForKey:@"date"]);
    
    UILabel *localeLabel = (UILabel*) [cell viewWithTag:105];
    localeLabel.text = [object objectForKey:@"locale"];
    //NSLog(@"%@", [object objectForKey:@"locale"]);

    UILabel *statusLabel = (UILabel*) [cell viewWithTag:106];
    statusLabel.text = [object objectForKey:@"status"];
    //NSLog(@"%@", [object objectForKey:@"status"]);
    return cell;
}

-(IBAction)close:(UIStoryboardSegue *)segue {
    
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    if(self.objects.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your search returned no listings!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"displayListing"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LFListingViewController *dest = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        dest.objectId = object.objectId;
        /*recipe.name = [object objectForKey:@"name"];
        recipe.imageFile = [object objectForKey:@"imageFile"];
        recipe.prepTime = [object objectForKey:@"prepTime"];
        recipe.ingredients = [object objectForKey:@"ingredients"];*/
        //destViewController.recipe = recipe;
        
    }
}



@end
