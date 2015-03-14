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
    searchBar.text=@"";
    
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
            /*NSString *feedbackAsString;
            float feedbackAsPercent;
            
            feedbackAsString = objects[0][@"rating"];
            feedbackAsPercent = feedbackAsString.floatValue;
            if(feedbackAsString == NULL) {
                feedbackAsString = @"0";
                feedbackAsPercent = 50;
                _noFeedbackField.text = @"No feedback";
            }
            _feedbackField.text = [NSString stringWithFormat:@"%@%%", feedbackAsString];
            _feedbackBar.progress = (feedbackAsPercent / 100);
            */
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    //[self filterContentForSearchText:searchString scope:
     //[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    //[self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
 */

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
