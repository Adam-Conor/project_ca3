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
            <UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchField;

@end
