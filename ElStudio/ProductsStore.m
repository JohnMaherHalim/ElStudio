//
//  ProductsStore.m
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "ProductsStore.h"

@implementation ProductsStore

+ (id)sharedManager {
    static ProductsStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    
    
    return sharedMyManager;
}

-(id)init {
    
    
    if (self = [super init])
    {
        self.Products = [[NSMutableArray alloc]init] ;
    }
    return self;
}

@end
