//
//  OrderItem.m
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

-(id)init {
    if (self = [super init])
    {
        self.ProductImages = [[NSMutableArray alloc]init] ;
        self.ImagesCounts = [[NSMutableArray alloc]init] ;
    }
    return self;
}

@end
