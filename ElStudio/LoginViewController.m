//
//  LoginViewController.m
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Login:(id)sender{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /* NSDictionary *parameters = @{@"email": self.UserName.text,@"password":self.Password.text,@"isFacebook":@NO};*/
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:self.UserName.text forKey:@"email"];
    [parameters setObject:self.Password.text forKey:@"password"];
    [parameters setObject:@NO forKey:@"isFacebook"];
    [manager POST:@"http://ws.elstud.io/api/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
