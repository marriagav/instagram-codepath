//
//  LoginViewController.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {
//    Method that registers the user
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    UIImage *image =  [UIImage imageNamed:@"profile_tab"];
    [newUser setObject:[Algos getPFFileFromImage:image] forKey: @"profileImage"];
    
//    Initialize alert controller
    [self initializeAlertController];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)loginUser {
//    Method that logs the user in
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
//    Initialize alert controller
    [self initializeAlertController];
    
//    Call log in function on the object
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)registerOnClick:(id)sender {
    [self registerUser];
}

- (IBAction)loginOnClick:(id)sender {
    [self loginUser];
}

- (void)initializeAlertController{
//    Create the alert controller
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                    message:@"Empty Field"
                    preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                    style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * _Nonnull action) {
                    // handle try again response here. Doing nothing will dismiss the view.
                    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
}

@end
