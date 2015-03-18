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
//@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UILabel *user;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) IBOutlet UILabel *locale;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *listingTitle;


@end
