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

@protocol LFLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LFLoginViewController *)controller;

@end

@interface LFLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<LFLoginViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end

#endif
