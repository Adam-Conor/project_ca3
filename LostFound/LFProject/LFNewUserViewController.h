//
//  LFNewUserViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 27/02/2015.
//
//

#import <UIKit/UIKit.h>
@class LFNewUserViewController;

@protocol LFNewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(LFNewUserViewController *)controller;


@end

@interface LFNewUserViewController : UIViewController
@property  (nonatomic, weak )id<LFNewUserViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passAgain;

@end
