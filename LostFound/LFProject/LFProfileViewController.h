//
//  LFProfileViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LFProfileViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *usernameField;
@property (nonatomic, weak) IBOutlet UILabel *memberField;
@property (nonatomic, weak) IBOutlet UILabel *emailField;
@property (nonatomic, weak) IBOutlet UIView *listingField;
@property (nonatomic, weak) IBOutlet UILabel *feedbackField;
@property (nonatomic, weak) IBOutlet UIProgressView *feedbackBar;
@property (weak, nonatomic) IBOutlet UILabel *noFeedbackField;

@end
