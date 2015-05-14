//
//  WholeOrder.m
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "WholeOrder.h"

@implementation WholeOrder

+ (id)sharedManager {
    static WholeOrder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    
   
    return sharedMyManager;
}

-(void)addtoOrderItems:(OrderItem*)item {
    [self.myOrder.OrderItems addObject:item] ;
    int i = [self.myOrder.OrderItems count];
}

-(id)init {
    if (self = [super init])
    {
        self.myOrder = [[Order alloc]init] ;
    }
    return self;
}

@end
