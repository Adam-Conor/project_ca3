//
//  LFLoginViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 26/02/2015.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class LFLoginViewController;

@interface LFLoginViewController : UIViewController
    <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end