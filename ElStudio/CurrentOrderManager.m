//
//  CurrentOrderManager.m
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "CurrentOrderManager.h"

@implementation CurrentOrderManager


+ (id)sharedManager {
    static CurrentOrderManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)storeProductName:(NSString*)productName  {
    self.curOrderItem.ProductName = productName ;
    NSLog(@"%@",self.curOrderItem.ProductName);
}

-(void)storeProductImages:(NSMutableArray *)productImages {
    self.curOrderItem.ProductImages = productImages ;
}

-(id)init {
    
    
    if (self = [super init])
    {
       self.curOrderItem = [[OrderItem alloc]init] ;
    }
    return self;
}

@end
