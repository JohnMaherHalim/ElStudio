//
//  AffineImageViewController.m
//  ElStudio
//
//  Created by John Maher on 4/28/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "AffineImageViewController.h"

@interface AffineImageViewController ()

@end

@implementation AffineImageViewController

@synthesize myimage, myimageview ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myimageview setImage:myimage];
    
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
