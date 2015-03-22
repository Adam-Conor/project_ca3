//
//  LFNewUserViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 27/02/2015.
//
//

#import "LFNewUserViewController.h"

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
    
    /* Set up gesture recognition */
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self registerForKeyboardNotifications];
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

/* Function for signing up
 * Shows errors if needed
 * If success signs user up
 */
- (void) processSignup {
    /* Set up strings */
    NSString *username = self.usernameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *passwordAgain = self.passAgain.text;
    NSString *emptyUser = @"Empty username /n";
    NSString *emptyPass = @"Empty password /n";
    NSString *emptyEmail = @"Empty email /n";
    NSString *noMatch = @"Please enter the same password. /n";
    NSString *errorText = @"";
    NSString *joinText = @", and ";
    
    BOOL textError = NO;
    
    /* Alert user of incomplete fields */
    if(username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        /* Set keyboard to first missing field */
        if(passwordAgain.length == 0) {
            [self.passAgain becomeFirstResponder];
        }
        
        if(password.length == 0) {
            [self.passwordField becomeFirstResponder];
        }
        
        if(username.length == 0) {
            [self.usernameField becomeFirstResponder];
        }
        
        if(email.length == 0){
            [self.emailField becomeFirstResponder];
        }
        
        /* Show error message */
        if(username.length == 0) {
            errorText = [errorText stringByAppendingString:emptyUser];
        }
        
        if(email.length == 0){
            errorText = [errorText stringByAppendingString:emptyEmail];
        }
        
        if(password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:emptyPass];
        }
    } else if([password compare:passwordAgain] != NSOrderedSame) {
        /* Check passwords are the same */
        textError = YES;
        errorText = [errorText stringByAppendingString:noMatch];
        
        [self.passwordField becomeFirstResponder];
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
    
    /* Get registration information */
    PFUser *user = [PFUser user];
    user.username = username;
    user.email = email;
    user.password = password;
    user[@"prof_image"] = [self getDefaultImage];
    
    /* Send user information to database */
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){ //show error if problem
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
            [self.usernameField becomeFirstResponder];
            
            return;
        } else {
            [self performSegueWithIdentifier:@"registerSuccess" sender:self];
        }
    }];
}

- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"close" sender:self];
}

/* Identify register key presses */
- (IBAction)registerPressed:(id)sender {
    [self dismissKeyboard];
    [self processSignup];
}

/* Close keyboard */
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

/* Gives user default profile image
 * They can change at a later date
 */
- (PFFile*)getDefaultImage {
    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
    NSData *imageData = UIImageJPEGRepresentation(defaultImage, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"default.png" data:imageData];
    
    return imageFile;
}

/* Keyboard functions */

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    
    CGFloat scrollViewOffsetY = (CGRectGetHeight(keyboardFrame) -
                                 (CGRectGetMaxY(self.view.bounds) -
                                  CGRectGetMaxY(self.registerAccount.frame) - 10.0f));
    
    if(scrollViewOffsetY < 0) {
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
