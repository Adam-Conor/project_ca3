//
//  LFCreateListingViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface LFCreateListingViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (nonatomic, strong) IBOutlet UITextField *listingTitle;
@property (strong, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) PFFile *uploadImage;
@property (strong, nonatomic) PFGeoPoint *location;
@property (nonatomic, assign) NSString *category;
@property (nonatomic, strong) PFGeoPoint *loc;
@end
