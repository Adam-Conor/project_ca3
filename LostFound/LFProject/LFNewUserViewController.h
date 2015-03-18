//
//  LFNewUserViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 27/02/2015.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class LFNewUserViewController;

@interface LFNewUserViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passAgain;

@end
