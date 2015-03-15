//
//  LFSearchViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFSearchViewController.h"

@interface LFSearchViewController ()

@end

@implementation LFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Assign the delegate */
    _searchField.delegate = self;
    
    /* Hide the scope bar until opened */
    _searchField.showsScopeBar = NO;
    
    /* Not sure what this does */
    [self.view addSubview:_searchField];
    
    /**** WHAT ARE THESE FOR ****/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
}

/* Runs when search bar opened
 * Shows scope bar and cancel button
 */

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

/* Runs when search bar closes
 * Hides scope bar and cancel button
 */

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    //searchBar.text=@"";
    
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

/* When user presses search
 * Get and prepares text for query
 * Queries for input text
 */

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    /* Get text for query */
    NSString *str = searchBar.text;
    NSInteger *scopeAsNum = searchBar.selectedScopeButtonIndex;
    
    /* Prepare text for query */
    str = [NSString stringWithFormat:@"^%@", str]; //case insensitive
    NSString *scopeAsString = [self scopeIndexToString:scopeAsNum];
    
    /* Test logs. To be removed */
    NSLog(@"%@", str);
    NSLog(@"%@", scopeAsString);
    
    /* Query for search */
    [self queryString:str queryScope:scopeAsString];
}

/* Runs when user pesses cancel
 * Exits search field
 */

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

/* Change the scope index to matching string
 * Returns string of status to search
 */

-(NSString*)scopeIndexToString:(int)num {
    NSString *scope;
    switch(num) {
        case 1:
            scope = @"lost";
            break;
        case 2:
            scope = @"found";
            break;
        default:
            scope = @"o";
            break;
    }
    
    return scope;
}

/* Query for search
 * ATM to just print the listings
 */

-(void)queryString:(NSString*)qString queryScope:(NSString*)qScope {
    /* Set what to query */
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    
    [query whereKey:@"title" matchesRegex:qString modifiers:@"i"];
    [query whereKey:@"status" containsString:qScope];
    
    /* Get query objects in array */
    [query findObjectsInBackgroundWithBlock:^(NSArray *listings, NSError *error) {
        if (!error) { //found match
            /* TODO
             * Put relevant info into view
             * Image - Title - Category?
             * Don't know how to do this yet
             * Allow for
             * Image/Location/Item
             */
            for(PFObject *listing in listings) {
                /* Get information to show */
                //get image somehow
                NSString *status = listing[@"status"];
                NSString *title = listing[@"title"];
                NSString *category = listing[@"category"];
                
                /* Test log */
                NSLog(@"\nStatus: %@\nTitle: %@\nCategory: %@", status, title, category);
                
                /* Somehow put information into view */
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Listing";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    prepTimeLabel.text = [object objectForKey:@""];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
