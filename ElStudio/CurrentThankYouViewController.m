//
//  CurrentThankYouViewController.m
//  ElStudio
//
//  Created by John Maher on 5/13/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "CurrentThankYouViewController.h"
#import "HomeViewController.h"

@interface CurrentThankYouViewController ()

@end

@implementation CurrentThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotocart {
    
    HomeViewController *home = (HomeViewController*)[self.navigationController.viewControllers firstObject] ;
    home.jumpflag = YES ;
    //[home performSegueWithIdentifier:@"GoToCart" sender:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)gotoOtherProduct:(id)sender {
    HomeViewController *home = (HomeViewController*)[self.navigationController.viewControllers firstObject] ;
    home.Productflag = YES ;
    //[home performSegueWithIdentifier:@"GoToCart" sender:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
