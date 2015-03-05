//
//  LFLoginViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 26/02/2015.
//
//

#ifndef LostFound_LFLoginViewController_h
#define LostFound_LFLoginViewController_h

#import <UIKit/UIKit.h>

@class LFLoginViewController;

@interface LFLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end

#endif
