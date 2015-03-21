//
//  LFMapListingViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 18/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LFMapListingViewController : UIViewController
@property (nonatomic, strong) NSString *objectPressed;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *category;
@property (nonatomic, strong) IBOutlet UILabel *user;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UITextView *desc;
@property (nonatomic, strong) IBOutlet UILabel *locale;
@property (nonatomic, strong) IBOutlet UILabel *email;
@property (nonatomic, strong) IBOutlet UILabel *phone;
@property (nonatomic, strong) IBOutlet UILabel *listingTitle;
@property (nonatomic, weak) IBOutlet UIButton *remove;


@end
