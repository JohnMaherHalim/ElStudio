//
//  InfoViewController.m
//  ElStudio
//
//  Created by John Maher on 6/8/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)GoToFeedBack:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [defaults objectForKey:@"UserID"];
    
    if (userId)
        [self performSegueWithIdentifier:@"GoToFeedBack" sender:nil];
    else {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You should login first to be able to send feedback" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
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
