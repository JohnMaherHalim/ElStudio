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

-(void)storeProduct:(Product*)prod {
    self.curOrderItem.product = prod ;
}

-(void)storeProductImages:(NSMutableArray *)productImages {
    self.curOrderItem.ProductImages = productImages ;
}

-(void)storeImagesCounts:(NSMutableArray*)imagecounts {
    self.curOrderItem.ImagesCounts = imagecounts ;
}

-(void)storeScales:(NSMutableArray*)imagesscales {
	self.curOrderItem.ImagesScales = imagesscales ; 
}

-(void)refreshOrderWithNumberOfImages:(NSInteger)currentCount {
    [self.curOrderItem.product setProduct_basicNumber:[NSNumber numberWithInt:3]];
    [self.curOrderItem.product setProduct_addonNumber:[NSNumber numberWithInt:2]];
    
    if (currentCount >= [self.curOrderItem.product.Product_basicNumber integerValue]) {
        //[[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:YES];
        [self.curOrderItem setBasicCheck:YES];
        NSInteger IndexAfter = currentCount - [self.curOrderItem.product.Product_basicNumber integerValue];
        NSInteger divided = IndexAfter/[self.curOrderItem.product.Product_addonNumber integerValue] ;
        if (IndexAfter % [self.curOrderItem.product.Product_addonNumber integerValue] != 0) {
            divided++ ;
        }
        [self.curOrderItem setAddOns:divided];
        //[[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:divided];
    }
    else {
        [self.curOrderItem setBasicCheck:NO];
        [self.curOrderItem setAddOns:0];
       /* [[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:NO];
        [[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:0];*/
    }
    
    if (self.curOrderItem.BasicCheck) {
        
        NSInteger AddOns1 = self.curOrderItem.AddOns;
        NSNumber *BasePrice = self.curOrderItem.product.Product_basicPrice ;
        NSNumber *AddOnPrice = self.curOrderItem.product.Product_addonPrice;
        NSInteger sum = 0 ;
        sum += [BasePrice integerValue] ;
        sum += AddOns1 * [AddOnPrice integerValue];
        self.curOrderItem.ItemPrice = sum ;
        
    }
    
}

-(id)init {
    
    
    if (self = [super init])
    {
       self.curOrderItem = [[OrderItem alloc]init] ;
    }
    return self;
}

@end
