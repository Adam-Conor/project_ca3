//
//  LFCreateListingViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFCreateListingViewController.h"
#import "LFCategoriesViewController.h"
#import <Parse/Parse.h>
#import <Listing.h>
#import <UIKit/UIKit.h>

@interface LFCreateListingViewController () <UITextFieldDelegate>

@end
static NSString *status;
static NSIndexPath *indexPath;
@implementation LFCreateListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(_cat);
}
- (IBAction)saveListing:(id)sender {
    [self createListing];
    [self performSegueWithIdentifier:@"saveListing" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear{
    //NSLog(@"%@ I'm printing from create listing view", self.category);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.section;
    if(cell.tag == 0 && [status isEqual:@"found"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSLog(@"Should have checkmarked it");
}

- (void) createListing{
    PFUser *user = [PFUser currentUser];
    PFObject *listing = [PFObject objectWithClassName:@"Listing"];
    //if(indexPath.row ==)
    //PFFile *image = ;
    [listing setObject:_listingTitle.text forKey:@"title"];
    listing[@"category"] = self.category;
    listing[@"user"] = user;
    listing[@"status"] = status;
    //listing[@"date"] = @;
    //listing[@"image"] = @"test";
    [listing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) NSLog(@"%s Listing saved succesfully", __PRETTY_FUNCTION__);
        else NSLog(@"%s Listing fucked up", __PRETTY_FUNCTION__);
    }];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.section;
    if(cell.tag == 2){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = indexPath.row;
        if(cell.tag == 0){
            status = @"lost";
        }
        else{
            status = @"found";
        }
    }
    else{
        cell.accessoryType = UITableViewCellSelectionStyleNone;
    }
    //listing[@"status]
}
-(IBAction)sendData:(UIStoryboardSegue *)segue {
    // Capitalise First letter for label on UI
    NSString *upper = self.category;
    upper = [self.category capitalizedString];
    self.catLabel.text = upper;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
    if ( indexPath.section == 0 ) return nil;
    
    // first 3 rows in any section should not be selectable
    
    // By default, allow row to be selected
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    if(cell.tag == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if(cell.tag == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}


@end