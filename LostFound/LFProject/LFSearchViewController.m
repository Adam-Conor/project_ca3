//
//  LFSearchViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFSearchViewController.h"

@interface LFSearchViewController ()

@property (nonatomic, weak) IBOutlet UILabel *listingLabel;

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
    
    /**** WHAT ARE THESE FOR ***/
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
    
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

/* When user presses search
 * TODO
 * 1) send text to DB and return results
 */

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    NSInteger *scopeAsNum = searchBar.selectedScopeButtonIndex;
    
    NSString *scopeAsString = [self scopeIndexToString:scopeAsNum];
    NSLog(@"%@", str);
    NSLog(@"%@", scopeAsString);
    [self queryString:str queryScope:scopeAsString];
}

/* Runs when user pesses cancel
 * Exits search field
 */

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

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
    
    [query whereKey:@"title" containsString:qString];
    [query whereKey:@"status" containsString:qScope];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
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
            for(PFObject *object in objects) {
                NSLog(@"%@", object);
            }
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
