//
//  CurrentItemPriceViewController.m
//  ElStudio
//
//  Created by John Maher on 6/1/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "CurrentItemPriceViewController.h"
#import "CurrentOrderManager.h"
#import "WholeOrder.h"

@interface CurrentItemPriceViewController ()

@end

@implementation CurrentItemPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   /* NSInteger AddOns1 = [[CurrentOrderManager sharedManager]AddOns];
    NSNumber *BasePrice = [[[[CurrentOrderManager sharedManager]curOrderItem]product]Product_basicPrice];
    NSNumber *AddOnPrice = [[[[CurrentOrderManager sharedManager]curOrderItem]product]Product_addonPrice];*/
    
    OrderItem *item = [[CurrentOrderManager sharedManager]curOrderItem];
    NSInteger sum = [self getSumOfImages:item.ImagesCounts];
    NSString *ImagesProduct = [NSString stringWithFormat:@"%ld %@",(long)sum,item.product.Product_name];
    NSString *Price = [NSString stringWithFormat:@"$ %ld",(long)item.ItemPrice];
    [self.NumberOfSquares setText:ImagesProduct];
    [self.ImagesCost setText:Price];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)getSumOfImages:(NSMutableArray*)CountsArray {
    NSInteger sum = 0 ;
    
    for (NSNumber *num in CountsArray) {
        sum += [num integerValue] ;
    }
    
    return  sum ;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderConfirmed"]) {
        OrderItem *orderitem = [[OrderItem alloc]init];
        orderitem.ProductName = [[[CurrentOrderManager sharedManager]curOrderItem]ProductName];
        orderitem.product = [[[CurrentOrderManager sharedManager]curOrderItem]product];
        orderitem.AddOns = [[[CurrentOrderManager sharedManager]curOrderItem]AddOns];
        orderitem.ItemPrice = [[[CurrentOrderManager sharedManager]curOrderItem]ItemPrice];
        orderitem.ProductImages = [[[CurrentOrderManager sharedManager]curOrderItem]ProductImages];
        orderitem.ImagesCounts = [[[CurrentOrderManager sharedManager]curOrderItem]ImagesCounts];
        orderitem.ImagesScales = [[[CurrentOrderManager sharedManager]curOrderItem]ImagesScales];
        [[WholeOrder sharedManager]addtoOrderItems:orderitem];
        [[WholeOrder sharedManager]SaveMyOrder];
    }
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
