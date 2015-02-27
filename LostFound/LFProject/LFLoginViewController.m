//
//  LFLoginViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 26/02/2015.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LFLoginViewController.h"
#import "LFNewUserViewController.h"

@interface LFLoginViewController ()
<UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL activityViewVisible;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton *login;

@end

@implementation LFLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) self.automaticallyAdjustsScrollViewInsets = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //[self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.activityView.frame = self.view.bounds;
    self.scrollView.contentSize = self.backgroundView.bounds.size;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (IBAction)signUp:(id)sender {
    [self showNewUserView];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField) {
        [self.usernameField becomeFirstResponder];
    }
    
    if(textField == self.passwordField){
        [self.passwordField becomeFirstResponder];
    }
    
    return YES;
}


- (void)showNewUserView {
    LFNewUserViewController *viewController = [[LFNewUserViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark Delegate

- (void)newUserViewControllerDidSignup:(LFNewUserViewController *)controller {
    [self.delegate loginViewControllerDidLogin:self];
}


- (void) getFieldValues{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *emptyUser = @"username";
    NSString *emptyPass = @"password";
    
    BOOL textError = NO;
    
    // If nothing entered, show error and set error field to be entered
    if(username.length == 0 || password.length == 0){
        textError = YES;
        
        if (username.length == 0)
            [self.usernameField becomeFirstResponder];
        
        if (password.length == 0){
            [self.passwordField becomeFirstResponder];
        }
    }
    
    /*if([username length] == 0){
        textError = YES;
        errorText = errorText
    }
    
    //Text errors -- will do later
     
    */
 
    self.activityViewVisible = YES;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
     self.activityViewVisible = NO;
        if(user){
            [self.delegate loginViewControllerDidLogin:self];
        }
        else{
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if(error){
                alertTitle = [error userInfo][@"error"];
            }
            
            else {
                alertTitle = @"Can't log in:(";
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            
            [self.usernameField becomeFirstResponder];
            
        }
     }
     ];
}
    
- (void)dismissKeyboard {
        [self.view endEditing:YES];
}
    
- (IBAction)loginPressed:(id)sender {
        [self dismissKeyboard];
        [self getFieldValues];
}
  /*
- (void) registerForKeyboardNotifications {
    
}
    
    
    /*- (void)setActivityViewVisible:(BOOL)visible{
        if (self.actvityViewVisible == visible) {
            return;
            
        }
        
        _activityViewVisible = visible;
        
        if(_activityViewVisible){
            
        }
    }
    */
    

@end



















