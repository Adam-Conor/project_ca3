//
//  LFCreateListingViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface LFCreateListingViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (nonatomic, strong) IBOutlet UITextField *listingTitle;
//@property (strong, nonatomic) IBOutlet UITextField *desc;
@property (strong, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) NSString *category;
@end
