//
//  LoginViewController.m
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_photos"];
    loginButton.delegate = self ;
    loginButton.center = self.view.center;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];

    [self.view addSubview:loginButton];
    // Do any additional setup after loading the view.
}

-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             /* NSDictionary *parameters = @{@"email": self.UserName.text,@"password":self.Password.text,@"isFacebook":@NO};*/
             NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
             [parameters setObject:result[@"email"] forKey:@"email"];
             [parameters setObject:@"" forKey:@"password"];
             [parameters setObject:@YES forKey:@"isFacebook"];
             [SVProgressHUD show];
             [manager POST:@"http://ws.elstud.io/api/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"JSON: %@", responseObject);
                 NSString *UserEmail = [responseObject objectForKey:@"email"];
                 NSString *userName = [responseObject objectForKey:@"name"];
                 NSString *userAddress = [responseObject objectForKey:@"address"];
                 NSString *userPhone = [responseObject objectForKey:@"phone"];
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:UserEmail forKey:@"UserEmail"];
                 [defaults setObject:userName forKey:@"UserName"];
                 [defaults setObject:userAddress forKey:@"UserAddress"];
                 [defaults setObject:userPhone forKey:@"UserPhone"];
                 [defaults synchronize] ;
                 [SVProgressHUD dismiss];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [SVProgressHUD dismiss];
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Wrong UserName or Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [msg show];
             }];

         }
     }];
    
    
    
}


- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error) {
        // Process error
    }
    else if (result.isCancelled) {
        // Handle cancellations
    }
    else {
        // Navigate to other view
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"UserName"];
        [defaults synchronize]; 
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Login:(id)sender{
    BOOL textempty = NO ;
    BOOL flag = NO ;
    for (UITextField *tfield in self.view.subviews) {
        if ([tfield isKindOfClass:[UITextField class]]) {
            flag = [self checktextfield:tfield];
            if (flag)
                textempty = YES;
        }
    }
    
    if (!textempty) {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /* NSDictionary *parameters = @{@"email": self.UserName.text,@"password":self.Password.text,@"isFacebook":@NO};*/
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:self.UserName.text forKey:@"email"];
    [parameters setObject:self.Password.text forKey:@"password"];
    [parameters setObject:@NO forKey:@"isFacebook"];
        [SVProgressHUD show];
    [manager POST:@"http://ws.elstud.io/api/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *UserEmail = [responseObject objectForKey:@"email"];
        NSString *userName = [responseObject objectForKey:@"name"];
        NSString *userAddress = [responseObject objectForKey:@"address"];
        NSString *userPhone = [responseObject objectForKey:@"phone"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UserEmail forKey:@"UserEmail"];
        [defaults setObject:userName forKey:@"UserName"];
        [defaults setObject:userAddress forKey:@"UserAddress"];
        [defaults setObject:userPhone forKey:@"UserPhone"];
        [defaults synchronize] ;
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Wrong UserName or Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show];
    }];
    } else {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You should fullfill all the fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    }
}

-(BOOL) checktextfield:(UITextField*)tfield {
    
    NSString *rawString = [tfield text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([tfield.text length] > 0 || [trimmed length] != 0 || [tfield.text isEqual:@""] == FALSE)
    {
        NSLog(@"%@",tfield.text);
        NSString *hoo = tfield.text ;
        return NO ;
        //do your work
    }
    else
    {
        return YES ;
        //through error
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
