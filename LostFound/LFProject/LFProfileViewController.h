//
//  LFProfileViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <UIKit/UIKit.h>

@interface LFProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *memberField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;
@property (weak, nonatomic) IBOutlet UIView *listingField;
@property (weak, nonatomic) IBOutlet UILabel *feedbackField;

//@property (nonatomic, strong) IBOutlet UIButton* signOut;
@end
