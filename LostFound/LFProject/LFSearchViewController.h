//
//  LFSearchViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LFSearchViewController : UITableViewController
    <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UISearchBar *searchField;
@property (nonatomic, weak) IBOutlet UILabel *listingLabel;


@end
