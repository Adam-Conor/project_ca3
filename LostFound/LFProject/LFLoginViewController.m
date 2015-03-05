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
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self performSegueWithIdentifier:@"register" sender:self];
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


#pragma mark Delegate

- (void) getFieldValues{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *emptyUser = @"username";
    NSString *emptyPass = @"password";
    NSString *errorText = @"No ";
    
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
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
        if(!error){
            [self performSegueWithIdentifier:@"login" sender:self];
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
       }];
}

- (void) dismissKeyboard {
        [self.view endEditing:YES];
}
    
- (IBAction)loginPressed:(id)sender {
        [self dismissKeyboard];
        [self getFieldValues];
}

//This is all to do with keyboards, not essential rn

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    
    CGFloat scrollViewOffsetY = (CGRectGetHeight(keyboardFrame) -
                                 (CGRectGetMaxY(self.view.bounds) -
                                  CGRectGetMaxY(self.login.frame) - 10.0f));
    
    if (scrollViewOffsetY < 0) {
        return;
    }
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0.0f, scrollViewOffsetY) animated:NO];
                     }
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                     }
                     completion:nil];
}


@end



















