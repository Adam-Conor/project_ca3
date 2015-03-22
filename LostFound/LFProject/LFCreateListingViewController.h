//
//  LFCreateListingViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import <Parse/Parse.h>

@interface LFCreateListingViewController : UITableViewController
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *catLabel;
@property (nonatomic, strong) IBOutlet UITextField *listingTitle;
@property (nonatomic, strong) IBOutlet UITextView *desc;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) PFFile *uploadImage;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, assign) NSString *category;
@property (nonatomic, strong) PFGeoPoint *loc;
@property (nonatomic, strong) NSString *locale;


@end
