//
//  WholeOrder.h
//  ElStudio
//
//  Created by John Maher on 5/12/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h" 
#import "OrderItem.h"

@interface WholeOrder : NSObject

@property (nonatomic,retain) Order *myOrder ;

-(void)addtoOrderItems:(OrderItem*)item ; 

+ (id)sharedManager;

@end
