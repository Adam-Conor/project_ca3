//
//  LFNewUserViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 27/02/2015.
//
//

#import "LFNewUserViewController.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface LFNewUserViewController () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL activityViewVisible;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet  UIButton *registerAccount;

@end


@implementation LFNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.emailField becomeFirstResponder];
    }
    if (textField == self.emailField){
        [self.passwordField becomeFirstResponder];
    }
    if (textField == self.passwordField) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField == self.passAgain) {
        [self.passAgain resignFirstResponder];
        [self processSignup];
    }
    
    return YES;
}




- (void) processSignup{
    NSString *username = self.usernameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *passwordAgain = self.passAgain.text;
    NSString *emptyUser = @"Empty username";
    NSString *emptyPass = @"Empty password";
    NSString *emptyEmail = @"Empty email";
    NSString *noMatch = @"Please enter the same password.";
    
    
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
    
    //self.activityViewVisible = YES;
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.email = email;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.usernameField becomeFirstResponder];
            return;
        }
        else{
            
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
        //[self.delegate newUserViewControllerDidSignup:self];
    }];
}
    
- (IBAction)registerPressed:(id)sender {
    [self dismissKeyboard];
    [self processSignup];
}


- (void) dismissKeyboard {
    [self.view endEditing:YES];
}


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
                                  CGRectGetMaxY(self.registerAccount.frame) - 10.0f));
    
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
