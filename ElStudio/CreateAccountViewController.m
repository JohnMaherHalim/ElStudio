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
    
    if ([self.Password.text isEqualToString:self.ConfirmPassword.text]) {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:self.UserName.text forKey:@"name"];
    [parameters setObject:self.Email.text forKey:@"email"];
    [parameters setObject:self.Password.text forKey:@"password"];
    [parameters setObject:self.Address.text forKey:@"address"];
    [parameters setObject:self.PhoneNumber.text forKey:@"phone"];
        [SVProgressHUD show];
    
    [manager POST:@"http://ws.elstud.io/api/user/signup" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss] ;
        [self login:responseObject]; 
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
    } else {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You should fullfill all the fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    }
}


-(void)login:(id)responseObject {
    NSNumber *UserID = [responseObject objectForKey:@"userId"];
    NSString *UserEmail = [responseObject objectForKey:@"email"];
    NSString *userName = [responseObject objectForKey:@"name"];
    NSString *userAddress = [responseObject objectForKey:@"address"];
    NSString *userPhone = [responseObject objectForKey:@"phone"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UserID forKey:@"UserID"];
    [defaults setObject:UserEmail forKey:@"UserEmail"];
    [defaults setObject:userName forKey:@"UserName"];
    [defaults setObject:userAddress forKey:@"UserAddress"];
    [defaults setObject:userPhone forKey:@"UserPhone"];
    [defaults synchronize] ;
    [self.navigationController popToRootViewControllerAnimated:YES] ;
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
