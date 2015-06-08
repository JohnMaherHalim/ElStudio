//
//  AboutUsViewController.m
//  ElStudio
//
//  Created by John Maher on 6/8/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ProductsStore.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Admin *myAdmin = [[ProductsStore sharedManager]myAdmin] ;
    
    [self.AddressLabel setText:myAdmin.Admin_Address];
    [self.PhoneLabel setText:myAdmin.Admin_Phone];
    [self.AboutUsLabel setText:myAdmin.Admin_AboutUs];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
