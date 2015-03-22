//
//  LFSearchResultsViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LFListingViewController.h"

@interface LFSearchResultsViewController : PFQueryTableViewController

@property (nonatomic, strong) NSString *searchStatus;
@property (nonatomic, strong) NSString *searchCat;

@end
