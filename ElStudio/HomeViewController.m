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
#import "WholeOrder.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
    
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
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSString *currentUser = [defaults objectForKey:@"UserID"];
    
    if (currentUser) {
        [self.LogIn setHidden:YES];
        [self.LogOut setHidden:NO];
    } else {
        [self.LogIn setHidden:NO];
        [self.LogOut setHidden:YES] ; 
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
        NSMutableArray *allProducts = [[NSMutableArray alloc]init] ;
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
            [allProducts addObject:myprod];
            
            //[[[ProductsStore sharedManager]Products]addObject:myprod];
           // [ProductsObjects addObject:myprod];
        }
        [self FilterAndSaveMyProducts:allProducts];
        [SVProgressHUD dismiss];
       // [ProductsStore sharedManager]
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error getting data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
    }];
    
}

-(void)FilterAndSaveMyProducts:(NSMutableArray*)AllProducts {
    
    NSMutableArray *Parents = [[NSMutableArray alloc]init];
    
    for (Product *ParentProduct in AllProducts) {
        if ([ParentProduct.Product_ParentId isKindOfClass:[NSNull class]])
            [Parents addObject:ParentProduct];
    }
    
    for (Product *product in AllProducts) {
        if (![product.Product_ParentId isKindOfClass:[NSNull class]]) {
            for (Product *ParentProd in Parents) {
                int prodid = [product.Product_ParentId intValue];
                int parentprodid = [ParentProd.Product_id intValue];
                
                if (prodid == parentprodid) {
                    [ParentProd.Product_SubProducts addObject:product];
                }
            }
        }
    }
    
   // [[[ProductsStore sharedManager]Products]addObject:myprod];
    [[ProductsStore sharedManager]setProducts:Parents];
    
}

-(IBAction)GoToCart:(id)sender{
    
    NSUserDefaults *dafaults = [NSUserDefaults standardUserDefaults] ;
    NSString *currentuser = [dafaults objectForKey:@"UserID"];
    
    if (currentuser) {
    NSMutableArray *items = [[[WholeOrder sharedManager]myOrder]OrderItems];
    if (items.count == 0) {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You don't have any products in your cart yet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    } else if (items.count > 0) {
        [self performSegueWithIdentifier:@"GoToCart" sender:nil];
    }
    } else {
        [self performSegueWithIdentifier:@"GoToLogin" sender:nil];
    }
}

-(IBAction)LogOut:(id)sender {
    [self.LogOut setHidden:YES];
    [self.LogIn setHidden:NO] ;
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"UserID"];
    [defaults setObject:nil forKey:@"UserEmail"];
    [defaults setObject:nil forKey:@"UserName"];
    [defaults setObject:nil forKey:@"UserAddress"];
    [defaults setObject:nil forKey:@"UserPhone"];
    [defaults synchronize] ;

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
