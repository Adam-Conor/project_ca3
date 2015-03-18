//
//  LFLoginViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 26/02/2015.
//
//

#import "LFLoginViewController.h"

@interface LFLoginViewController ()

@property (nonatomic, assign) BOOL activityViewVisible;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton *login;

@end

@implementation LFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Set up gesture recognition */
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(dismissKeyboard)];
    
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.activityView.frame = self.view.bounds;
    self.scrollView.contentSize = self.backgroundView.bounds.size;
}

/* Set status bar style */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/* Button for user registration */
- (IBAction)signUp:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField) {
        [self.usernameField becomeFirstResponder];
    }
    
    if(textField == self.passwordField) {
        [self.passwordField becomeFirstResponder];
    }
    
    return YES;
}


#pragma mark Delegate

- (void)getFieldValues {
    /* Set up strings */
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *emptyUser = @"Username";
    NSString *emptyPass = @"Password";
    NSString *errorText = @"Please ";
    
    BOOL textError = NO;
    
    /* Alert user if incomplete fields */
    if(username.length == 0 || password.length == 0){
        textError = YES;
        
        if(username.length == 0) {
            [self.usernameField becomeFirstResponder];
        }
        
        if(password.length == 0) {
            [self.passwordField becomeFirstResponder];
        }
    }
    
    /* Show error messages */
    if([username length] == 0) {
        textError = YES;
        errorText = [errorText stringByAppendingString:emptyUser];
    }
    
    if ([password length] == 0) {
        textError = YES;
        
        if ([username length] == 0) {
            errorText = [errorText stringByAppendingString:emptyUser];
        }
        
        errorText = [errorText stringByAppendingString:emptyPass];
    }
    
    if(textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        
        [alertView show];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if(!error){ //if user found
            [self performSegueWithIdentifier:@"login" sender:self];
        } else {
            NSString *alertTitle = nil;
            
            if(error) {
                alertTitle = [error userInfo][@"error"];
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            
            [alertView show];
            
            [self.usernameField becomeFirstResponder];
        }
       }];
}

/* Hide keyboard function */
- (void) dismissKeyboard {
        [self.view endEditing:YES];
}

/* Button for login */
- (IBAction)loginPressed:(id)sender {
        [self dismissKeyboard];
        [self getFieldValues];
}

/* Keyboard functions */
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