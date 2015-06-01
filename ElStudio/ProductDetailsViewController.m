//
//  ProductDetailsViewController.m
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "ProductDetailsViewController.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *ResolutionString = [NSString stringWithFormat:@"%@ x %@",self.myproduct.Product_imagewidth,self.myproduct.Product_imageheight];
    NSString *BasicPriceString = [NSString stringWithFormat:@"$ %@",self.myproduct.Product_basicPrice];
    NSString *AddOnPriceString = [NSString stringWithFormat:@"$ %@",self.myproduct.Product_addonPrice];
    NSString *BasicNumberString = [NSString stringWithFormat:@"First %@ Prints ",self.myproduct.Product_basicNumber];
    NSString *AddOnNumberString = [NSString stringWithFormat:@"Each Additional %@ Prints ",self.myproduct.Product_addonNumber];
    
    [self.Resolution setText:ResolutionString];
    [self.BasicNumber setText:BasicNumberString];
    [self.BasicPrice setText:BasicPriceString];
    [self.AddOnNumber setText:AddOnNumberString];
    [self.AddOnPrice setText:AddOnPriceString];
    
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
