//
//  CreateAccountViewController.m
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)CreateAccount:(id)sender {
    
    if ([self.Password.text isEqualToString:self.ConfirmPassword.text]) {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:self.UserName.text forKey:@"name"];
    [parameters setObject:self.Email.text forKey:@"email"];
    [parameters setObject:self.Password.text forKey:@"password"];
    [parameters setObject:self.Address.text forKey:@"address"];
    [parameters setObject:self.PhoneNumber.text forKey:@"phone"];
        NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc]init];
        [parameters1 setObject:parameters forKey:@"user"];
        [SVProgressHUD show];
    [manager POST:@"http://ws.elstud.io/api/user/signup" parameters:parameters1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss] ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error getting data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
        [SVProgressHUD dismiss];
    }];
    } else {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Make sure that your password matches in both text fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show];
    }
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
