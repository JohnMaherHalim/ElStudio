//
//  HomeViewController.m
//  ElStudio
//
//  Created by John Maher on 5/13/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Product.h"
#import "ProductsStore.h"
#import "SVProgressHUD.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getGlobalData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.jumpflag) {
        self.jumpflag = NO ;
        [self performSegueWithIdentifier:@"GoToCart" sender:nil];
    }
    
    if (self.Productflag) {
        self.Productflag = NO ;
        [self performSegueWithIdentifier:@"GoToProducts" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getGlobalData {
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://ws.elstud.io/api/global/getglobal" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *products = [responseObject objectForKey:@"products"];
        NSMutableArray *ProductsObjects = [[NSMutableArray alloc]init];
        for (NSDictionary *prod in products) {
            Product *myprod = [[Product alloc]init] ;
            myprod.Product_id = [prod objectForKey:@"id"];
            myprod.Product_name = [prod objectForKey:@"name"];
            myprod.Product_description = [prod objectForKey:@"description"];
            myprod.Product_ParentId = [prod objectForKey:@"parentProductId"];
            myprod.Product_basicNumber = [prod objectForKey:@"basicNumber"];
            myprod.Product_basicPrice = [prod objectForKey:@"basicPrice"];
            myprod.Product_addonNumber = [prod objectForKey:@"addOnNumber"];
            myprod.Product_addonPrice = [prod objectForKey:@"addOnPrice"];
            myprod.Product_imageheight = [prod objectForKey:@"imageHeight"];
            myprod.Product_imagewidth = [prod objectForKey:@"imageWidth"];
            [[[ProductsStore sharedManager]Products]addObject:myprod];
           // [ProductsObjects addObject:myprod];
        }
        [SVProgressHUD dismiss];
       // [ProductsStore sharedManager]
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error getting data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
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
