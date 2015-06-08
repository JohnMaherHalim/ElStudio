//
//  FeedbackViewController.m
//  ElStudio
//
//  Created by John Maher on 6/8/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textView setText:@""];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SendFeedback:(id)sender{
    NSString *rawString = [self.textView text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([self.textView.text length] > 0 || [trimmed length] != 0 || [self.textView.text isEqual:@""] == FALSE) {
        [self sendtoServer:self.textView.text];
    } else {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You should write your feedback first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    }
}

-(void)sendtoServer:(NSString*)text {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSNumber *userID = [defaults objectForKey:@"UserID"];
    
    
    [parameters setObject:userID forKey:@"userId"];
    [parameters setObject:text forKey:@"feedbackText"];
    [parameters setObject:[NSDate date] forKey:@"date"];
    
    [SVProgressHUD show];
    [manager POST:@"http://ws.elstud.io/api/user/sendfeedback" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, your feedback could not have been sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show];
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
