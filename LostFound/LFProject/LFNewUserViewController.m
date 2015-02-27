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
        
        [self.delegate newUserViewControllerDidSignup:self];
    }];
}
    
- (IBAction)registerPressed:(id)sender {
    [self processSignup];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
